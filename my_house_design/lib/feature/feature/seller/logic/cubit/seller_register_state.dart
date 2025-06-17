import 'package:my_house_design/feature/feature/seller/data/models/seller_registermodel.dart';

abstract class SellerRegisterState {}

class SellerRegisterInitial extends SellerRegisterState {}

class SellerRegisterLoading extends SellerRegisterState {}

class SellerRegisterSuccess extends SellerRegisterState {
  final SellerRegisterModel model;

  SellerRegisterSuccess(this.model);
}

class SellerRegisterFailure extends SellerRegisterState {
  final String error;

  SellerRegisterFailure(this.error);
}
