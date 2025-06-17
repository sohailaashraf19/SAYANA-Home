
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/reset_repo.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/resetpass_state.dart';


class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepository repository;

  ResetPasswordCubit(this.repository) : super(ResetPasswordInitial());

  static ResetPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final result = await repository.resetPassword(
        email: email,
        otp: otp,
        password: password,
        confirmPassword: confirmPassword,
      );
      emit(ResetPasswordSuccess(result.message));
    } catch (e) {
       print("🔴 ERROR: $e");
      emit(ResetPasswordError("Reset password failed"));
    }
  }
}
