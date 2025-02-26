import 'package:bloc/bloc.dart';
import 'package:chopee/blocs/cart/cart_events.dart';
import 'package:chopee/blocs/cart/cart_states.dart';
import 'package:chopee/model/cart.dart';
import 'package:chopee/network/sample_network_service.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final NetworkService _networkService;

  CartBloc({required NetworkService networkService})
      : _networkService = networkService,
        super(const CartInitial()) {
    on<CartLoaded>(_onCartLoaded);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemUpdated>(_onCartItemUpdated);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartCleared>(_onCartCleared);
  }

  Future<void> _onCartLoaded(CartLoaded event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cart = await _networkService.cartApi.getCart();
      emit(CartLoadSuccess(cart));
    } catch (e) {
      emit(CartLoadFailure(e.toString()));
    }
  }

  Future<void> _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    if (state is CartLoadSuccess) {
      final currentState = state as CartLoadSuccess;
      emit(CartUpdating(currentState.cart));
      
      try {
        final updatedCart = await _networkService.cartApi.addToCart(event.cartItem);
        emit(CartLoadSuccess(updatedCart));
      } catch (e) {
        emit(CartLoadFailure(e.toString()));
      }
    }
  }

  Future<void> _onCartItemUpdated(CartItemUpdated event, Emitter<CartState> emit) async {
    if (state is CartLoadSuccess) {
      final currentState = state as CartLoadSuccess;
      emit(CartUpdating(currentState.cart));
      
      try {
        await _networkService.cartApi.updateCartItem(event.productId, event.quantity);
        final updatedCart = await _networkService.cartApi.getCart();
        emit(CartLoadSuccess(updatedCart));
      } catch (e) {
        emit(CartLoadFailure(e.toString()));
      }
    }
  }

  Future<void> _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    if (state is CartLoadSuccess) {
      final currentState = state as CartLoadSuccess;
      emit(CartUpdating(currentState.cart));
      
      try {
        await _networkService.cartApi.removeFromCart(event.productId);
        final updatedCart = await _networkService.cartApi.getCart();
        emit(CartLoadSuccess(updatedCart));
      } catch (e) {
        emit(CartLoadFailure(e.toString()));
      }
    }
  }

  Future<void> _onCartCleared(CartCleared event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      // TODO: networking: clear cart
      final emptyCart = Cart.empty();
      emit(CartLoadSuccess(emptyCart));
    } catch (e) {
      emit(CartLoadFailure(e.toString()));
    }
  }
}
