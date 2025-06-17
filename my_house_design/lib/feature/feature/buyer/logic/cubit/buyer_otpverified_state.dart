abstract class BuyerOtpState {}

class BuyerOtpInitial extends BuyerOtpState {}

class BuyerOtpLoading extends BuyerOtpState {}

class BuyerOtpSuccess extends BuyerOtpState {
  final String message;
  BuyerOtpSuccess(this.message);
}

class BuyerOtpError extends BuyerOtpState {
  final String message;
  BuyerOtpError(this.message);
}
