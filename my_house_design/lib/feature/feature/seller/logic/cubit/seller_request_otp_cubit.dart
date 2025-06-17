import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_request_otp_state.dart';
import 'package:dio/dio.dart';

class SellerRequestOtpCubit extends Cubit<SellerRequestOtpState> {
  SellerRequestOtpCubit() : super(SellerRequestOtpInitial());

  static SellerRequestOtpCubit get(context) => BlocProvider.of(context);

  Future<void> requestOtp(String email) async {
    emit(SellerRequestOtpLoading());
    try {
      final response = await Dio().post(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/seller/forgot-password/request-otp?email=$email',
      );

      final message = response.data['message'];
      emit(SellerRequestOtpSuccess(message));
    } catch (e) {
      emit(SellerRequestOtpError(e.toString()));

    }
  }
}
