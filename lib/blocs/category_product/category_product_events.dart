import 'package:equatable/equatable.dart';

abstract class CategoryProductEvent extends Equatable {
  const CategoryProductEvent();

  @override
  List<Object?> get props => [];
}

class CategoryProductsLoaded extends CategoryProductEvent {
  final String categoryName;
  
  const CategoryProductsLoaded(this.categoryName);
  
  @override
  List<Object?> get props => [categoryName];
}
