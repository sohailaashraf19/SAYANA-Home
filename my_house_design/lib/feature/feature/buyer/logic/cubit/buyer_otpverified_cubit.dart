import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/buyer/data/repositories/buyerotp_repo.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_otpverified_state.dart';

class BuyerOtpCubit extends Cubit<BuyerOtpState> {
  final BuyerOtpRepository repository;

  BuyerOtpCubit(this.repository) : super(BuyerOtpInitial());

  static BuyerOtpCubit get(context) => BlocProvider.of(context);

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(BuyerOtpLoading());
    try {
      final result = await repository.verifyOtp(email: email, otp: otp);
      emit(BuyerOtpSuccess(result.message));
    } catch (e) {
      print("🔴 ERROR: $e");
      emit(BuyerOtpError("Verification failed"));
    }
  }
}
