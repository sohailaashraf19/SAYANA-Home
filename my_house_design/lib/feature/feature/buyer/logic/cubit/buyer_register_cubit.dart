import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_house_design/feature/feature/buyer/data/repositories/buyer_auth_repo.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_register_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerRegisterCubit extends Cubit<BuyerRegisterState> {
  final BuyerAuthRepo buyerAuthRepo;

  BuyerRegisterCubit(this.buyerAuthRepo) : super(BuyerRegisterInitial());

  static BuyerRegisterCubit get(context) => BlocProvider.of(context);

  Future<void> registerBuyer({
  required String name, 
  required String phone,
  required String email,
  required String password,
  required String passwordConfirmation,
}) async {
  emit(BuyerRegisterLoading());
  try {
    final result = await buyerAuthRepo.registerBuyer(
      name: name, 
      phone: phone,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', result.token);

    emit(BuyerRegisterSuccess(result));
  } catch (e) {
    emit(BuyerRegisterFailure(e.toString()));
  }
}
}