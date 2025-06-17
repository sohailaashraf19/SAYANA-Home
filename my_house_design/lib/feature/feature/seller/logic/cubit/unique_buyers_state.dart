import 'package:my_house_design/feature/feature/seller/data/models/uniquebuyers_model.dart';

abstract class UniqueBuyersState {}

class UniqueBuyersInitial extends UniqueBuyersState {}

class UniqueBuyersLoading extends UniqueBuyersState {}

class UniqueBuyersLoaded extends UniqueBuyersState {
  final UniqueBuyersModel data;

  UniqueBuyersLoaded(this.data);
}

class UniqueBuyersError extends UniqueBuyersState {
  final String message;

  UniqueBuyersError(this.message);
}
