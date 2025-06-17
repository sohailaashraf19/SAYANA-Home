import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/buyer/data/repositories/buyer_search_repository.dart';
import 'buyer_search_state.dart';

class BuyerSearchCubit extends Cubit<BuyerSearchState> {
  final BuyerSearchRepository repository;
  Timer? _debounce;

  BuyerSearchCubit(this.repository) : super(BuyerSearchInitial());

  static BuyerSearchCubit get(context) => BlocProvider.of(context);

  void search(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        emit(BuyerSearchInitial());
        return;
      }

      emit(BuyerSearchLoading());
      try {
        final results = await repository.search(query);
        emit(BuyerSearchSuccess(results));
      } catch (e) {
        emit(BuyerSearchError(e.toString()));
      }
    });
  }
}
