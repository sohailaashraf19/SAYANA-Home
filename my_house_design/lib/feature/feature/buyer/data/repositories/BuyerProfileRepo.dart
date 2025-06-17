import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerProfileRepo {
  final String baseUrl = 'https://olivedrab-llama-457480.hostingersite.com/public/api';

  // Fetch Profile Data
  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Debugging: Print token to ensure it's retrieved correctly
      print('Token: $token');

      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/buyer/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Debugging: Print the status code and response body
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Debugging: Check if 'data' is available in the response
        print('Response Data: $data');

        if (data != null) {
  return data;

        } else {
          throw Exception('Profile data is missing or malformed');
        }
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      // Debugging: Print the error message
      print('Error fetching profile: $e');
      throw Exception('Error fetching profile: $e');
    }
  }

  // Update Profile Data
}