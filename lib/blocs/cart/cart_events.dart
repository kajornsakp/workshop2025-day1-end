import 'package:equatable/equatable.dart';
import 'package:chopee/model/cart_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartEvent {
  const CartLoaded();
}

class CartItemAdded extends CartEvent {
  final CartItem cartItem;

  const CartItemAdded(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class CartItemUpdated extends CartEvent {
  final String productId;
  final int quantity;

  const CartItemUpdated(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class CartItemRemoved extends CartEvent {
  final String productId;

  const CartItemRemoved(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartCleared extends CartEvent {
  const CartCleared();
}
