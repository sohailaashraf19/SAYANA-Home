import 'package:my_house_design/feature/feature/buyer/data/models/product_model.dart';

abstract class BuyerSearchState {}

class BuyerSearchInitial extends BuyerSearchState {}

class BuyerSearchLoading extends BuyerSearchState {}

class BuyerSearchSuccess extends BuyerSearchState {
  final List<ProductModel> results;

  BuyerSearchSuccess(this.results);
}

class BuyerSearchError extends BuyerSearchState {
  final String message;

  BuyerSearchError(this.message);
}
