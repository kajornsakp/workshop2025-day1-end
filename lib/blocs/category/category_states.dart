import 'package:chopee/model/category.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoriesLoading extends CategoryState {
  const CategoriesLoading();
}

class CategoriesLoadSuccess extends CategoryState {
  final List<Category> categories;

  const CategoriesLoadSuccess(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesLoadFailure extends CategoryState {
  final String message;

  const CategoriesLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
