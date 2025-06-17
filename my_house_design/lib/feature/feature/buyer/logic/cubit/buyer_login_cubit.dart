import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/feature/feature/buyer/data/repositories/buyer_auth_repo.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerLoginCubit extends Cubit<BuyerLoginState> {
  final BuyerAuthRepo buyerAuthRepo;

  BuyerLoginCubit(this.buyerAuthRepo) : super(BuyerLoginInitial());

  Future<void> loginBuyer({
    required String email,
    required String password,
  }) async {
    emit(BuyerLoginLoading());
    try {
      final result = await buyerAuthRepo.loginBuyer(
        email: email,
        password: password,
      );
      print('🔁 Login result buyer id: ${result.buyer.id}');
      
      final prefs = await SharedPreferences.getInstance();

      // Save token
      await prefs.setString('token', result.token);
      print('✅ Saved token is: ${prefs.getString('token')}');

      // Save buyer ID
      await CacheHelper.saveData(key: 'buyerId', value: result.buyer.id);
      print('👤 Buyer ID: ${result.buyer.id}');

      // Save buyer name
      await prefs.setString('buyerName', result.buyer.name);  // Save the buyer's name
      print('✅ Saved buyer name: ${prefs.getString('buyerName')}'); // Check if the buyer name is saved

      emit(BuyerLoginSuccess(result));
    } catch (e) {
      emit(BuyerLoginFailure(e.toString()));
    }
  }

  static BuyerLoginCubit get(context) => BlocProvider.of(context);
}
