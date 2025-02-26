import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class ProductDetailLoaded extends ProductDetailEvent {
  final String productId;

  const ProductDetailLoaded(this.productId);

  @override
  List<Object?> get props => [productId];
}
