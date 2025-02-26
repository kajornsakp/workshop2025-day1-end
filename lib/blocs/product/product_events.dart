import 'package:equatable/equatable.dart';
import 'package:chopee/model/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductsLoaded extends ProductEvent {
  final String? category;
  final String? search;

  const ProductsLoaded({this.category, this.search});

  @override
  List<Object?> get props => [category, search];
}

class ProductDetailLoaded extends ProductEvent {
  final String productId;

  const ProductDetailLoaded(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductCreated extends ProductEvent {
  final Product product;

  const ProductCreated(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductUpdated extends ProductEvent {
  final String productId;
  final Product product;

  const ProductUpdated(this.productId, this.product);

  @override
  List<Object?> get props => [productId, product];
}

class ProductDeleted extends ProductEvent {
  final String productId;

  const ProductDeleted(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SellerProductsLoaded extends ProductEvent {
  const SellerProductsLoaded();
}
