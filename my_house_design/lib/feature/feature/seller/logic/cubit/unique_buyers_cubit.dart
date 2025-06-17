import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/data/data_sources/count_remote_data_source.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/unique_buyers_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UniqueBuyersCubit extends Cubit<UniqueBuyersState> {
  final SummaryRemoteDataSource dataSource;

  UniqueBuyersCubit(this.dataSource) : super(UniqueBuyersInitial());

  Future<void> getUniqueBuyers() async {
    try {
      emit(UniqueBuyersLoading());

      final prefs = await SharedPreferences.getInstance();
      final sellerIdStr = prefs.getString('seller_id') ?? ''; // ✅ fixed key
      final sellerId = int.tryParse(sellerIdStr) ?? 0;

      final data = await dataSource.fetchUniqueBuyers(sellerId);
      emit(UniqueBuyersLoaded(data));
    } catch (e) {
      emit(UniqueBuyersError(e.toString()));
    }
  }
}
