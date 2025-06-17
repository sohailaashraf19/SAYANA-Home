abstract class BuyerLogoutState {}

class BuyerLogoutInitial extends BuyerLogoutState {}

class BuyerLogoutLoading extends BuyerLogoutState {}

class BuyerLogoutSuccess extends BuyerLogoutState {
  final String message;

  BuyerLogoutSuccess(this.message);
}

class BuyerLogoutError extends BuyerLogoutState {
  final String error;

  BuyerLogoutError(this.error);
}
