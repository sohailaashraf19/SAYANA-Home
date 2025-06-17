import 'package:dio/dio.dart';
import 'package:my_house_design/core/core/network/dio_helper.dart';
import 'package:my_house_design/core/core/network/endpoints.dart';

import 'package:my_house_design/feature/feature/buyer/data/models/buyer_loginmodel.dart';
import 'package:my_house_design/feature/feature/buyer/data/models/buyer_registermodel.dart';

class BuyerAuthRepo {
  Future<BuyerLoginModel> loginBuyer({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await DioHelper.postData(
        url: ApiConstants.buyerLogin, 
        data: {
          "email": email,
          "password": password,
        },
      );
      print('🔁 Login API Response: ${response.data}');

      return BuyerLoginModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data["message"] ?? "Login failed");
      } else {
        throw Exception("Login failed: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }

  //register
Future<BuyerRegisterModel> registerBuyer({
  required String name,
  required String phone,
  required String email,
  required String password,
  required String passwordConfirmation,
}) async {
  final response = await DioHelper.postData(
    url: ApiConstants.buyerRegister,
    data: {
      'name': name, 
      'phone': phone,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    },
  );

  return BuyerRegisterModel.fromJson(response.data);
}







}
