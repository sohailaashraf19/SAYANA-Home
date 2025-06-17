import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/feature/feature/seller/data/models/TopSellingProductModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> _getSellerIdFromCache() async {
  final prefs = await SharedPreferences.getInstance();
  String? sellerId = prefs.getString('seller_id'); // Adjust key if needed

  if (sellerId != null && sellerId.isNotEmpty) {
    print("Seller ID from cache: $sellerId");
    return sellerId;
  } else {
    print("No seller ID found in cache.");
    return '';
  }
}

class TopSellingProductCubit extends Cubit<List<TopSellingProduct>> {
  TopSellingProductCubit() : super([]);

  Future<void> fetchTopSellingProducts() async {
    final sellerId = await _getSellerIdFromCache(); // Get seller ID from cache
    print("Retrieved Seller ID: $sellerId");

    if (sellerId.isEmpty) {
      print("No seller ID found in cache.");
      return;
    }

    print("Fetching top-selling products for seller ID: $sellerId");
    final products = await _fetchProductsFromApi(sellerId);

    if (products != null && products.isNotEmpty) {
      print("Top-selling products fetched successfully.");
      emit(products);
    } else {
      print("No products found or API response is empty.");
    }
  }

  Future<List<TopSellingProduct>?> _fetchProductsFromApi(String sellerId) async {
  final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getTopSellingProducts?seller_id=$sellerId'); // Use GET method with seller_id in query parameters

  try {
    final response = await http.get(url); // Use GET request

    if (response.statusCode == 200) {
      print("API Response: ${response.body}");
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        return data.map((item) => TopSellingProduct.fromJson(item)).toList();
      } else {
        print("Empty product list received.");
      }
    } else {
      print("API error with status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching top-selling products: $e");
  }

  return null;
}
}