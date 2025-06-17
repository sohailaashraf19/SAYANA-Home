// reset_password_repository.dart
import 'package:dio/dio.dart';
import 'package:my_house_design/feature/feature/buyer/data/models/buyerresetpass_model.dart';


class BuyerresetRepository {
  final Dio dio;

  BuyerresetRepository(this.dio);

  Future<ResetPasswordResponse> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await dio.post(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/forgot-password/reset',
      data: {
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': confirmPassword,
      },
    );

    return ResetPasswordResponse.fromJson(response.data);
  }
}
