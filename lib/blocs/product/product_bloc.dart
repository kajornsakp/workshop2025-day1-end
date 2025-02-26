import 'package:bloc/bloc.dart';
import 'package:chopee/blocs/product/product_events.dart';
import 'package:chopee/blocs/product/product_states.dart';
import 'package:chopee/network/sample_network_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final NetworkService _networkService;

  ProductBloc({required NetworkService networkService})
      : _networkService = networkService,
        super(const ProductInitial()) {
    on<ProductsLoaded>(_onProductsLoaded);
    on<ProductCreated>(_onProductCreated);
    on<ProductUpdated>(_onProductUpdated);
    on<ProductDeleted>(_onProductDeleted);
    on<SellerProductsLoaded>(_onSellerProductsLoaded);
  }

  Future<void> _onProductsLoaded(ProductsLoaded event, Emitter<ProductState> emit) async {
    emit(const ProductsLoading());
    try {
      final products = await _networkService.productApi.getAllProducts(
        category: event.category,
        search: event.search,
      );
      emit(ProductsLoadSuccess(products, category: event.category, search: event.search));
    } catch (e) {
      emit(ProductsLoadFailure(e.toString()));
    }
  }

  Future<void> _onProductCreated(ProductCreated event, Emitter<ProductState> emit) async {
    emit(const ProductOperationLoading());
    try {
      await _networkService.productApi.createProduct(event.product);
      emit(const ProductOperationSuccess('Product created successfully'));
    } catch (e) {
      emit(ProductOperationFailure(e.toString()));
    }
  }

  Future<void> _onProductUpdated(ProductUpdated event, Emitter<ProductState> emit) async {
    emit(const ProductOperationLoading());
    try {
      await _networkService.productApi.updateProduct(event.productId, event.product);
      emit(const ProductOperationSuccess('Product updated successfully'));
    } catch (e) {
      emit(ProductOperationFailure(e.toString()));
    }
  }

  Future<void> _onProductDeleted(ProductDeleted event, Emitter<ProductState> emit) async {
    emit(const ProductOperationLoading());
    try {
      await _networkService.productApi.deleteProduct(event.productId);
      emit(const ProductOperationSuccess('Product deleted successfully'));
    } catch (e) {
      emit(ProductOperationFailure(e.toString()));
    }
  }

  Future<void> _onSellerProductsLoaded(SellerProductsLoaded event, Emitter<ProductState> emit) async {
    emit(const SellerProductsLoading());
    try {
      final products = await _networkService.productApi.getSellerProducts();
      emit(SellerProductsLoadSuccess(products));
    } catch (e) {
      emit(SellerProductsLoadFailure(e.toString()));
    }
  }
}
