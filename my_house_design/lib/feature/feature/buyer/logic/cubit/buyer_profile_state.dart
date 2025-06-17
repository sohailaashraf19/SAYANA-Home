abstract class BuyerProfileState {}

/// ───── Initial State ─────
class BuyerProfileInitial extends BuyerProfileState {}

/// ───── Loading States ─────
class BuyerProfileLoading extends BuyerProfileState {}       // Fetching profile
class BuyerProfileUpdating extends BuyerProfileState {}      // Updating profile

/// ───── Success States ─────
class BuyerProfileSuccess extends BuyerProfileState {
  final Map<String, dynamic> profileData;
  BuyerProfileSuccess(this.profileData);
}

class BuyerProfileUpdateSuccess extends BuyerProfileState {} // Profile updated successfully

/// ───── Failure States ─────
class BuyerProfileFailure extends BuyerProfileState {
  final String error;
  BuyerProfileFailure(this.error);
}

class BuyerProfileUpdateFailure extends BuyerProfileState {
  final String error;
  BuyerProfileUpdateFailure(this.error);
}
