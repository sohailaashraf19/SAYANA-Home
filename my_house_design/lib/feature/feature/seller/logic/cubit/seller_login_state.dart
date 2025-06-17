import 'package:my_house_design/feature/feature/seller/data/models/seller_loginmodel.dart';

abstract class SellerLoginState {}

class SellerLoginInitial extends SellerLoginState {}

class SellerLoginLoading extends SellerLoginState {}

class SellerLoginSuccess extends SellerLoginState {
  final SellerLoginModel seller;

  SellerLoginSuccess(this.seller);
}

class SellerLoginFailure extends SellerLoginState {
  final String error;

  SellerLoginFailure(this.error);
}
