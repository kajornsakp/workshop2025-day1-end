import 'package:bloc/bloc.dart';
import 'package:chopee/blocs/category/category_events.dart';
import 'package:chopee/blocs/category/category_states.dart';
import 'package:chopee/network/sample_network_service.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final NetworkService _networkService;

  CategoryBloc({required NetworkService networkService})
      : _networkService = networkService,
        super(const CategoryInitial()) {
    on<CategoriesLoaded>(_onCategoriesLoaded);
  }

  Future<void> _onCategoriesLoaded(CategoriesLoaded event, Emitter<CategoryState> emit) async {
    emit(const CategoriesLoading());
    try {
      final categories = await _networkService.categoryApi.getAllCategories();
      emit(CategoriesLoadSuccess(categories));
    } catch (e) {
      emit(CategoriesLoadFailure(e.toString()));
    }
  }
}
