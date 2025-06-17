abstract class SellerRequestOtpState {}

class SellerRequestOtpInitial extends SellerRequestOtpState {}

class SellerRequestOtpLoading extends SellerRequestOtpState {}

class SellerRequestOtpSuccess extends SellerRequestOtpState {
  final String message;

  SellerRequestOtpSuccess(this.message);
}

class SellerRequestOtpError extends SellerRequestOtpState {
  final String error;

  SellerRequestOtpError(this.error);
}
