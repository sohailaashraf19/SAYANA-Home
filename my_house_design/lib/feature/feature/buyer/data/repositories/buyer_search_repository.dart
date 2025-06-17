import 'package:dio/dio.dart';
import '../models/product_model.dart';

class BuyerSearchRepository {
  final Dio dio;

  BuyerSearchRepository(this.dio);

  Future<List<ProductModel>> search(String query) async {
    final response = await dio.get(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/search',
      queryParameters: {'query': query},
    );

    final data = response.data as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
