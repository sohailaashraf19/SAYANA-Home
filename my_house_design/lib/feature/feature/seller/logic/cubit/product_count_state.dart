

import 'package:my_house_design/feature/feature/seller/data/models/product_count_model.dart';

abstract class ProductCountState {}

class ProductCountInitial extends ProductCountState {}

class ProductCountLoading extends ProductCountState {}

class ProductCountLoaded extends ProductCountState {
  final ProductCountModel data;
  ProductCountLoaded(this.data);
}

class ProductCountError extends ProductCountState {
  final String message;
  ProductCountError(this.message);
}
