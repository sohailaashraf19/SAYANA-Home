import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/seller_auth_repo.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_register_state.dart';


class SellerRegisterCubit extends Cubit<SellerRegisterState> {
  final SellerAuthRepo sellerAuthRepo;

  SellerRegisterCubit(this.sellerAuthRepo) : super(SellerRegisterInitial());

  Future<void> registerSeller({
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String brandName,
  }) async {
    emit(SellerRegisterLoading());
    try {
      final result = await sellerAuthRepo.registerSeller(
        phone: phone,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        brandName: brandName,
      );
      emit(SellerRegisterSuccess(result));
    } catch (e) {
      if (e is DioException) {
  final errorMessage = e.response?.data['message'] ?? 'Registration failed. Try again.';
  emit(SellerRegisterFailure(errorMessage));
} else {
  emit(SellerRegisterFailure('Unexpected error occurred.'));
}

    }
  }

  static SellerRegisterCubit get(context) =>
      BlocProvider.of<SellerRegisterCubit>(context);
}
