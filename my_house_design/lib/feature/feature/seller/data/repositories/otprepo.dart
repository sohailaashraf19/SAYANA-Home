import 'package:dio/dio.dart';
import 'package:my_house_design/feature/feature/seller/data/models/otp_model.dart';


class OtpRepository {
  final Dio dio;

  OtpRepository(this.dio);

  Future<OtpVerifyResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await dio.post(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/seller/forgot-password/verify-otp',
      queryParameters: {'email': email, 'otp': otp},
    );

    return OtpVerifyResponse.fromJson(response.data);
  }
}
