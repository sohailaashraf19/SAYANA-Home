abstract class BuyerRequestOtpState {}

class BuyerRequestOtpInitial extends BuyerRequestOtpState {}

class BuyerRequestOtpLoading extends BuyerRequestOtpState {}

class BuyerRequestOtpSuccess extends BuyerRequestOtpState {
  final String message;

  BuyerRequestOtpSuccess(this.message);
}

class BuyerRequestOtpError extends BuyerRequestOtpState {
  final String error;

  BuyerRequestOtpError(this.error);
}
