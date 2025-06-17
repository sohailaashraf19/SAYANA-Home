import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/data/data_sources/count_remote_data_source.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/revenue_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RevenueCubit extends Cubit<RevenueState> {
  final SummaryRemoteDataSource dataSource;

  RevenueCubit(this.dataSource) : super(RevenueInitial());

  Future<void> getRevenue() async {
    try {
      emit(RevenueLoading());

      final prefs = await SharedPreferences.getInstance();
      final sellerIdStr = prefs.getString('seller_id') ?? ''; // ✅ fixed key
      final sellerId = int.tryParse(sellerIdStr) ?? 0;

      final data = await dataSource.fetchRevenue(sellerId);
      emit(RevenueLoaded(data));
    } catch (e) {
      emit(RevenueError(e.toString()));
    }
  }
}
