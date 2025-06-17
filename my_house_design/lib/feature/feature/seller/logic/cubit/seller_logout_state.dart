abstract class SellerLogoutState {}

class SellerLogoutInitial extends SellerLogoutState {}

class SellerLogoutLoading extends SellerLogoutState {}

class SellerLogoutSuccess extends SellerLogoutState {
  final String message;

  SellerLogoutSuccess(this.message);
}

class SellerLogoutError extends SellerLogoutState {
  final String error;

  SellerLogoutError(this.error);
}
