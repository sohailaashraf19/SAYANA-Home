import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/feature/feature/seller/data/models/HighestSpendingCustomerModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> _getSellerIdFromCache() async {
  final prefs = await SharedPreferences.getInstance();
  String? sellerId = prefs.getString('seller_id'); // Adjust this key if necessary

  if (sellerId != null && sellerId.isNotEmpty) {
    print("Seller ID from cache: $sellerId");
    return sellerId;
  } else {
    print("No seller ID found in cache.");
    return ''; // Return an empty string if no seller ID is found
  }
}

class HighestSpendingCustomerCubit extends Cubit<List<HighestSpendingCustomer>> {
  HighestSpendingCustomerCubit() : super([]);

  Future<void> fetchHighestSpendingCustomers() async {
    final sellerId = await _getSellerIdFromCache(); // Retrieve seller ID from cache
    print("Retrieved Seller ID: $sellerId");

    if (sellerId.isEmpty) {
      print("No seller ID found in cache.");
      return; // Handle the case where sellerId is not found
    }

    print("Fetching data for seller ID: $sellerId");

    // Fetch data using the correct sellerId
    final response = await fetchDataFromApi(sellerId);

    if (response != null && response.isNotEmpty) {
      print("Data fetched successfully.");
      emit(response); // Emit the fetched data to the state
    } else {
      print("No data fetched or API response is empty.");
    }
  }

  Future<List<HighestSpendingCustomer>?> fetchDataFromApi(String sellerId) async {
    final url = 'https://olivedrab-llama-457480.hostingersite.com/public/api/sellerstop-customers/$sellerId';
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print("API Response: ${response.body}");

        // Parse the response body to a List of HighestSpendingCustomer
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return data.map((customer) => HighestSpendingCustomer.fromJson(customer)).toList();
        } else {
          print("No customers found in the API response.");
        }
      } else {
        print("Error: API response code ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return null; // Return null if the data fetch failed or there was an error
  }
}
