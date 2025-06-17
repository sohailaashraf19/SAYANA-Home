import 'package:dio/dio.dart';
import 'package:my_house_design/feature/feature/buyer/data/models/otpverified_model.dart';


class BuyerOtpRepository {
  final Dio dio;

  BuyerOtpRepository(this.dio);

  Future<OtpVerifyResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await dio.post(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/forgot-password/verify-otp',
      queryParameters: {'email': email, 'otp': otp},
    );

    return OtpVerifyResponse.fromJson(response.data);
  }
}
