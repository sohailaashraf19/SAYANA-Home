import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:my_house_design/core/core/helper/cache_helper.dart';

// States
abstract class HistoryOrderState {}

class HistoryOrderInitial extends HistoryOrderState {}
class HistoryOrderLoading extends HistoryOrderState {}
class HistoryOrderSuccess extends HistoryOrderState {
  final List<dynamic> orders;
  HistoryOrderSuccess(this.orders);
}
class HistoryOrderFailure extends HistoryOrderState {
  final String error;
  HistoryOrderFailure(this.error);
}

// Cubit
class HistoryOrderCubit extends Cubit<HistoryOrderState> {
  HistoryOrderCubit() : super(HistoryOrderInitial());

  Future<void> fetchHistoryOrders() async {
    emit(HistoryOrderLoading());
    
    // Retrieve the buyerId from cache
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    
    if (buyerId == null) {
      emit(HistoryOrderFailure('Buyer ID not found in cache'));
      return;
    }
    
    try {
      final response = await Dio().get(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/history_order/$buyerId',
      );
      print('History API response: ${response.data}'); // 👀 Add this

      final data = response.data;
      // depending on the shape
      if (data is Map && data.containsKey('orders')) {
        emit(HistoryOrderSuccess(data['orders']));
      } else if (data is List) {
        emit(HistoryOrderSuccess(data));
      } else {
        emit(HistoryOrderFailure('Unexpected API response'));
      }
    } catch (e) {
      emit(HistoryOrderFailure(e.toString()));
    }
  }
}
