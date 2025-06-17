
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/buyer/data/repositories/buyerreset_repo.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyerpass_state.dart';


class BuyerResetPasswordCubit extends Cubit<BuyerResetPasswordState> {
  final BuyerresetRepository repository;

  BuyerResetPasswordCubit(this.repository) : super(BuyerResetPasswordInitial());

  static BuyerResetPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    emit(BuyerResetPasswordLoading());
    try {
      final result = await repository.resetPassword(
        email: email,
        otp: otp,
        password: password,
        confirmPassword: confirmPassword,
      );
      emit(BuyerResetPasswordSuccess(result.message));
    } catch (e) {
       print("🔴 ERROR: $e");
      emit(BuyerResetPasswordError("Reset password failed"));
    }
  }
}
