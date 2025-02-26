import 'package:chopee/blocs/category_product/category_product_events.dart';
import 'package:chopee/blocs/category_product/category_product_states.dart';
import 'package:chopee/network/sample_network_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryProductBloc extends Bloc<CategoryProductEvent, CategoryProductState> {
  final NetworkService _networkService;

  CategoryProductBloc({required NetworkService networkService})
      : _networkService = networkService,
        super(const CategoryProductInitial()) {
    on<CategoryProductsLoaded>(_onCategoryProductsLoaded);
  }

  Future<void> _onCategoryProductsLoaded(CategoryProductsLoaded event, Emitter<CategoryProductState> emit) async {
    emit(const CategoryProductsLoading());
    try {
      final products = await _networkService.categoryApi.getProductsByCategory(event.categoryName.toLowerCase());
      emit(CategoryProductsLoadSuccess(products, event.categoryName));
    } catch (e) {
      emit(CategoryProductsLoadFailure(e.toString()));
    }
  }
}
