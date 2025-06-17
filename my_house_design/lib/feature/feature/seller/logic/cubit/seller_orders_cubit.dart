import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/data/data_sources/count_remote_data_source.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_orders_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersCountCubit extends Cubit<OrdersCountState> {
  final SummaryRemoteDataSource dataSource;

  OrdersCountCubit(this.dataSource) : super(OrdersCountInitial());

  Future<void> getOrdersCount() async {
    try {
      emit(OrdersCountLoading());

      final prefs = await SharedPreferences.getInstance();
      final sellerIdStr = prefs.getString('seller_id') ?? ''; // ✅ fixed key
      final sellerId = int.tryParse(sellerIdStr) ?? 0;

      if (sellerId == 0) {
        emit(OrdersCountError("Seller ID not found or invalid"));
        return;
      }

      final data = await dataSource.fetchOrdersCount(sellerId);
      emit(OrdersCountLoaded(data));
    } catch (e) {
      emit(OrdersCountError(e.toString()));
    }
  }
}
