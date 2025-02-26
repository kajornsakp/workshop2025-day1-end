import 'package:chopee/model/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

class ProductDetailLoadSuccess extends ProductDetailState {
  final Product product;

  const ProductDetailLoadSuccess(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDetailLoadFailure extends ProductDetailState {
  final String message;

  const ProductDetailLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
