import 'package:my_house_design/feature/feature/seller/data/models/revenue_model.dart';

abstract class RevenueState {}

class RevenueInitial extends RevenueState {}

class RevenueLoading extends RevenueState {}

class RevenueLoaded extends RevenueState {
  final RevenueModel data;
  RevenueLoaded(this.data);
}

class RevenueError extends RevenueState {
  final String message;
  RevenueError(this.message);
}
