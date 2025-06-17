// reset_password_state.dart
abstract class  BuyerResetPasswordState {}

class BuyerResetPasswordInitial extends BuyerResetPasswordState {}

class BuyerResetPasswordLoading extends BuyerResetPasswordState {}

class BuyerResetPasswordSuccess extends BuyerResetPasswordState {
  final String message;
  BuyerResetPasswordSuccess(this.message);
}

class BuyerResetPasswordError extends BuyerResetPasswordState {
  final String error;
  BuyerResetPasswordError(this.error);
}
