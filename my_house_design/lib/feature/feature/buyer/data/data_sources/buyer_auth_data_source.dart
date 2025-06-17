import 'package:dio/dio.dart';
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/core/core/network/dio_helper.dart';
import 'package:my_house_design/core/core/network/endpoints.dart';


class BuyerAuthRemoteDataSource {
  Future<Response> logoutBuyer() async {
    final token = await CacheHelper.getData(key: 'token');
    print('Token: $token');
    return await DioHelper.postData(
      url: ApiConstants.buyerLogout,
      token: token,
    );
  }

    //forget password 

    Future<Response> forgotPassword({required String email}) async {
    return await DioHelper.postData(
      url:ApiConstants.buyerforgpass ,
      data: {
        'email': email,
      });}




}
