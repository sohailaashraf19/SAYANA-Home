// reset_password_repository.dart
import 'package:dio/dio.dart';
import 'package:my_house_design/feature/feature/seller/data/models/resetpass_model.dart';


class ResetPasswordRepository {
  final Dio dio;

  ResetPasswordRepository(this.dio);

  Future<ResetPasswordResponse> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await dio.post(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/seller/forgot-password/reset',
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
