import 'package:dio/dio.dart';
import 'package:my_house_design/feature/feature/buyer/data/models/product_model.dart';

class BuyerSearchRemoteDataSource {
  final Dio dio = Dio();
  final String baseUrl = "https://olivedrab-llama-457480.hostingersite.com/public/api/search?query=";

  Future<List<ProductModel>> search(String query) async {
    try {
      final response = await dio.get("$baseUrl$query");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw Exception("Search failed with status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Search failed: $e");
    }
  }
}
