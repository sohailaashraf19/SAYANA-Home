// otp_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/otprepo.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/otpverify_state.dart';


class OtpCubit extends Cubit<OtpState> {
  final OtpRepository repository;

  OtpCubit(this.repository) : super(OtpInitial());

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(OtpLoading());
    try {
      final result = await repository.verifyOtp(email: email, otp: otp);
      emit(OtpSuccess(result.message));
    } catch (e) {
  print("🔴 ERROR: $e");
  emit(OtpError("Verification failed"));
}

  }

  static OtpCubit get(context) => BlocProvider.of(context);
}
