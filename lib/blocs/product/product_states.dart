import 'package:chopee/model/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductsLoading extends ProductState {
  const ProductsLoading();
}

class ProductsLoadSuccess extends ProductState {
  final List<Product> products;
  final String? category;
  final String? search;

  const ProductsLoadSuccess(this.products, {this.category, this.search});

  @override
  List<Object?> get props => [products, category, search];
}

class ProductsLoadFailure extends ProductState {
  final String message;

  const ProductsLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductDetailLoading extends ProductState {
  const ProductDetailLoading();
}

class ProductDetailLoadSuccess extends ProductState {
  final Product product;

  const ProductDetailLoadSuccess(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDetailLoadFailure extends ProductState {
  final String message;

  const ProductDetailLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductOperationLoading extends ProductState {
  const ProductOperationLoading();
}

class ProductOperationSuccess extends ProductState {
  final String message;
  
  const ProductOperationSuccess(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ProductOperationFailure extends ProductState {
  final String message;
  
  const ProductOperationFailure(this.message);
  
  @override
  List<Object?> get props => [message];
}

class SellerProductsLoading extends ProductState {
  const SellerProductsLoading();
}

class SellerProductsLoadSuccess extends ProductState {
  final List<Product> products;
  
  const SellerProductsLoadSuccess(this.products);
  
  @override
  List<Object?> get props => [products];
}

class SellerProductsLoadFailure extends ProductState {
  final String message;
  
  const SellerProductsLoadFailure(this.message);
  
  @override
  List<Object?> get props => [message];
}
