import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/feature/feature/seller/logic/cubit/SellerProfileState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerProfileCubit extends Cubit<SellerProfileState> {
  SellerProfileCubit() : super(SellerProfileInitial());

  final String _baseUrl = 'https://olivedrab-llama-457480.hostingersite.com/public/api';

  Future<void> fetchProfile() async {
    emit(SellerProfileLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(SellerProfileFailure("No token found"));
        return;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/seller/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
  print('✅ API Response: ${response.body}');

  final rawData = jsonDecode(response.body);

  // ✅ Use rawData directly since there's no "data" key
  emit(SellerProfileSuccess(rawData));
} else {
  emit(SellerProfileFailure("Failed to fetch profile"));
}
 
    } catch (e) {
      emit(SellerProfileFailure("Exception: $e"));
    }
  }
}
