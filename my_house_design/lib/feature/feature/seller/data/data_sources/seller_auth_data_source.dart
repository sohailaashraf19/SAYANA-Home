import 'package:dio/dio.dart';
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/core/core/network/dio_helper.dart';
import 'package:my_house_design/core/core/network/endpoints.dart';


class SellerAuthRemoteDataSource {
  Future<Response> logoutSeller() async {
    final token = await CacheHelper.getData(key: 'token');
    return await DioHelper.postData(
      url: ApiConstants.sellerLogout,
      token: token,
      data: {}, 
    );
  }
}
