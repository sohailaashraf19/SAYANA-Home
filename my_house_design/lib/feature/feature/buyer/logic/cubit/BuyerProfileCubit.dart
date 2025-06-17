import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'buyer_profile_state.dart';

class BuyerProfileCubit extends Cubit<BuyerProfileState> {
  BuyerProfileCubit() : super(BuyerProfileInitial());

  final String _baseUrl =
      'https://olivedrab-llama-457480.hostingersite.com/public/api';

  Future<void> fetchProfile() async {
    emit(BuyerProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(BuyerProfileFailure('No token found'));
        return;
      }

      final res = await http.get(
        Uri.parse('$_baseUrl/buyer/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final raw = jsonDecode(res.body);
        emit(BuyerProfileSuccess(raw));
      } else {
        emit(BuyerProfileFailure('Fetch failed: ${res.statusCode}'));
      }
    } catch (e) {
      emit(BuyerProfileFailure('Exception: $e'));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    emit(BuyerProfileUpdating());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(BuyerProfileUpdateFailure('No token found'));
        return;
      }

      final res = await http.put(
        Uri.parse('$_baseUrl/buyer/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
        }),
      );

      if (res.statusCode == 200) {
        emit(BuyerProfileUpdateSuccess());
        fetchProfile();
      } else {
        emit(BuyerProfileUpdateFailure(
            'Update failed: ${res.statusCode} ${res.reasonPhrase}'));
      }
    } catch (e) {
      emit(BuyerProfileUpdateFailure('Exception: $e'));
    }
  }
}
