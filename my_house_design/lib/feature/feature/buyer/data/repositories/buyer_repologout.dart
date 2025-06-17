

import 'package:dio/dio.dart';
import 'package:my_house_design/feature/feature/buyer/data/data_sources/buyer_auth_data_source.dart';

class BuyerRepository {
  final BuyerAuthRemoteDataSource remoteDataSource;

  BuyerRepository(this.remoteDataSource);

  Future<Response> logoutBuyer() async {
    return await remoteDataSource.logoutBuyer();
  }

  // forgetpassword haa

   Future<String> forgotPassword({required String email}) async {
    final response = await remoteDataSource.forgotPassword(email: email);
    return response.data['message'];
   }



}
