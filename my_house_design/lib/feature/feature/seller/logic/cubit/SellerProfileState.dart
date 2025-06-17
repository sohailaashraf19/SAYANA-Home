abstract class SellerProfileState {}

class SellerProfileInitial extends SellerProfileState {}

class SellerProfileLoading extends SellerProfileState {}

class SellerProfileSuccess extends SellerProfileState {
  final Map<String, dynamic> profileData;

  SellerProfileSuccess(this.profileData);
}

class SellerProfileFailure extends SellerProfileState {
  final String error;

  SellerProfileFailure(this.error);
}
