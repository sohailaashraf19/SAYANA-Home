import 'package:my_house_design/feature/feature/buyer/data/models/buyer_loginmodel.dart';

abstract class BuyerLoginState {}

class BuyerLoginInitial extends BuyerLoginState {}

class BuyerLoginLoading extends BuyerLoginState {}

class BuyerLoginSuccess extends BuyerLoginState {
  final BuyerLoginModel model;
  BuyerLoginSuccess(this.model);
}

class BuyerLoginFailure extends BuyerLoginState {
  final String error;
  BuyerLoginFailure(this.error);
}
