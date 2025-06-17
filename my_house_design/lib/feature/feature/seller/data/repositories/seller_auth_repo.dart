import 'package:dio/dio.dart';
import 'package:my_house_design/core/core/network/dio_helper.dart';
import 'package:my_house_design/core/core/network/endpoints.dart';

import 'package:my_house_design/feature/feature/seller/data/models/seller_loginmodel.dart';
import 'package:my_house_design/feature/feature/seller/data/models/seller_registermodel.dart';


class SellerAuthRepo {
  Future<SellerLoginModel> loginSeller({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await DioHelper.postData(
        url: ApiConstants.sellerLogin,
        data: {
          "email": email,
          "password": password,
        },
      );

      return SellerLoginModel.fromJson(response.data);
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



      //sellerRegisterd

Future<SellerRegisterModel> registerSeller({
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String brandName,
  }) async {
 

    try {
      final response = await DioHelper.postData(
        url: ApiConstants.sellerRegister,
        data: {
          "phone": phone,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "brand_name": brandName,
        },
      );

    

      return SellerRegisterModel.fromJson(response.data);
    } catch (e) {
      
      throw Exception("Register failed: ${e.toString()}");
    }
  }
}