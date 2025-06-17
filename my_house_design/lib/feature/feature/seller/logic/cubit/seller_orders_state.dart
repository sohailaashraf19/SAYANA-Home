import 'package:my_house_design/feature/feature/seller/data/models/sellerOrders_Model.dart';

abstract class OrdersCountState {}

class OrdersCountInitial extends OrdersCountState {}

class OrdersCountLoading extends OrdersCountState {}

class OrdersCountLoaded extends OrdersCountState {
  final OrdersCountModel data;
  OrdersCountLoaded(this.data);
}

class OrdersCountError extends OrdersCountState {
  final String message;
  OrdersCountError(this.message);
}
