import 'package:my_house_design/feature/feature/buyer/data/models/buyer_registermodel.dart';

abstract class BuyerRegisterState {}

class BuyerRegisterInitial extends BuyerRegisterState {}

class BuyerRegisterLoading extends BuyerRegisterState {}

class BuyerRegisterSuccess extends BuyerRegisterState {
  final BuyerRegisterModel registerModel;
  BuyerRegisterSuccess(this.registerModel);
}

class BuyerRegisterFailure extends BuyerRegisterState {
  final String error;
  BuyerRegisterFailure(this.error);
}
