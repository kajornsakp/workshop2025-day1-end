import 'package:bloc/bloc.dart';
import 'package:chopee/blocs/product_detail/product_detail_events.dart';
import 'package:chopee/blocs/product_detail/product_detail_states.dart';
import 'package:chopee/network/sample_network_service.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final NetworkService _networkService;

  ProductDetailBloc({required NetworkService networkService})
      : _networkService = networkService,
        super(const ProductDetailInitial()) {
    on<ProductDetailLoaded>(_onProductDetailLoaded);
  }

  Future<void> _onProductDetailLoaded(ProductDetailLoaded event, Emitter<ProductDetailState> emit) async {
    emit(const ProductDetailLoading());
    try {
      final product = await _networkService.productApi.getProductById(event.productId);
      emit(ProductDetailLoadSuccess(product));
    } catch (e) {
      emit(ProductDetailLoadFailure(e.toString()));
    }
  }
}
