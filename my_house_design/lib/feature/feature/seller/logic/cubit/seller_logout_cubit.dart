import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/seller_repologout.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_logout_state.dart';



class SellerLogoutCubit extends Cubit<SellerLogoutState> {
  final SellerRepository repository;

  SellerLogoutCubit(this.repository) : super(SellerLogoutInitial());

  static SellerLogoutCubit get(context) => BlocProvider.of(context);

  Future<void> logoutSeller() async {
    emit(SellerLogoutLoading());
    try {
      final response = await repository.logoutSeller();
      final message = response.data['message'];
      emit(SellerLogoutSuccess(message));
    } catch (e) {
      emit(SellerLogoutError(e.toString()));
    }
  }
}
