import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/otprequest_state.dart';
import 'package:dio/dio.dart';

class BuyerRequestOtpCubit extends Cubit<BuyerRequestOtpState> {
  BuyerRequestOtpCubit() : super(BuyerRequestOtpInitial());

  static BuyerRequestOtpCubit get(context) => BlocProvider.of(context);

  Future<void> requestOtp(String email) async {
    emit(BuyerRequestOtpLoading());
    try {
      final response = await Dio().post(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/forgot-password/request-otp?email=$email',
      );

      final message = response.data['message'];
      emit(BuyerRequestOtpSuccess(message));
    } catch (e) {
      emit(BuyerRequestOtpError(e.toString()));

    }
  }
}
