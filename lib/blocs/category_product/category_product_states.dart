import 'package:chopee/model/product.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryProductState extends Equatable {
  const CategoryProductState();

  @override
  List<Object?> get props => [];
}

class CategoryProductInitial extends CategoryProductState {
  const CategoryProductInitial();
}


class CategoryProductsLoading extends CategoryProductState {
  const CategoryProductsLoading();
}

class CategoryProductsLoadSuccess extends CategoryProductState {
  final List<Product> products;
  final String categoryName;

  const CategoryProductsLoadSuccess(this.products, this.categoryName);

  @override
  List<Object?> get props => [products, categoryName];
}

class CategoryProductsLoadFailure extends CategoryProductState {
  final String message;

  const CategoryProductsLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}