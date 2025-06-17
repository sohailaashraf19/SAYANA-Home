import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/core/core/network/dio_helper.dart';

import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_logout_state.dart';

class BuyerLogoutCubit extends Cubit<BuyerLogoutState> {
  BuyerLogoutCubit() : super(BuyerLogoutInitial());

  static BuyerLogoutCubit get(BuildContext context) =>
      BlocProvider.of<BuyerLogoutCubit>(context);

  Future<void> logoutBuyer() async {
    emit(BuyerLogoutLoading());
    try {
      final token = await CacheHelper.getData(key: 'token');

      final response = await DioHelper.postData(
        url: 'buyer/logout',
        token: token,
        data: {},
      );

      final message = response.data['message']; 
      print('Logout response message: $message'); 

      await CacheHelper.removeData(key: 'token');

      emit(BuyerLogoutSuccess(message)); 
    } catch (e) {
      emit(BuyerLogoutError(e.toString()));
    }
  }
}
