import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/seller_auth_repo.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerLoginCubit extends Cubit<SellerLoginState> {
  final SellerAuthRepo sellerAuthRepo;

  SellerLoginCubit(this.sellerAuthRepo) : super(SellerLoginInitial());

  static SellerLoginCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> loginSeller({
  required String email,
  required String password,
}) async {
  emit(SellerLoginLoading());
  try {
    final seller = await sellerAuthRepo.loginSeller(
      email: email,
      password: password,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', seller.token);
    await prefs.setString('seller_id', seller.seller.sellerId.toString()); // Save seller ID
    await prefs.setString('userName', seller.seller.brandname); // Save seller name
    print('✅ Saved token is: ${prefs.getString('token')}');
    print('✅ Saved seller ID is: ${prefs.getString('seller_id')}');
    print('✅ Saved seller name is: ${prefs.getString('userName')}'); // Check if seller name is saved

    emit(SellerLoginSuccess(seller));
  } catch (e) {
    emit(SellerLoginFailure(e.toString().replaceFirst("Exception: ", "")));
  }
}
}