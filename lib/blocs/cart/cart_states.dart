import 'package:equatable/equatable.dart';
import 'package:chopee/model/cart.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoadSuccess extends CartState {
  final Cart cart;

  const CartLoadSuccess(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartLoadFailure extends CartState {
  final String message;

  const CartLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CartUpdating extends CartState {
  final Cart currentCart;

  const CartUpdating(this.currentCart);

  @override
  List<Object?> get props => [currentCart];
}
