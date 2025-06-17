import 'package:dio/dio.dart';
import 'package:my_house_design/feature/feature/seller/data/data_sources/seller_auth_data_source.dart';

class SellerRepository {
  final SellerAuthRemoteDataSource remoteDataSource;

  SellerRepository(this.remoteDataSource);

  Future<Response> logoutSeller() async {
    return await remoteDataSource.logoutSeller();
  }
}
