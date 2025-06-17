import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_house_design/feature/feature/seller/data/data_sources/count_remote_data_source.dart';
import 'product_count_state.dart';

class ProductCountCubit extends Cubit<ProductCountState> {
  final SummaryRemoteDataSource dataSource;

  ProductCountCubit(this.dataSource) : super(ProductCountInitial());

  Future<void> getProductCount() async {
    try {
      emit(ProductCountLoading());

      final prefs = await SharedPreferences.getInstance();
      final sellerIdStr = prefs.getString('seller_id');           // ✅ fixed
      if (sellerIdStr == null) {
        throw Exception('❌ seller_id is missing in SharedPreferences');
      }

      final sellerId = int.tryParse(sellerIdStr);
      if (sellerId == null || sellerId == 0) {
        throw Exception('❌ Invalid seller_id: $sellerId');
      }

      final data = await dataSource.fetchProductCount(sellerId);
      emit(ProductCountLoaded(data));
    } catch (e) {
      emit(ProductCountError(e.toString()));
    }
  }
}
