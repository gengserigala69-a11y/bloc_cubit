part of 'category_bloc.dart';

abstract class CategoryState {}

/// Initial state
class CategoryInitial extends CategoryState {}

/// Loading state
class CategoryLoading extends CategoryState {}

/// Success load list
class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoaded({required this.categories});
}

/// Success create
class CategoryCreateSuccess extends CategoryState {
  final List<CategoryModel> categories;

  CategoryCreateSuccess({required this.categories});
}

/// Success update
class CategoryUpdateSuccess extends CategoryState {
  final List<CategoryModel> categories;

  CategoryUpdateSuccess({required this.categories});
}

/// Success delete
class CategoryDeleteSuccess extends CategoryState {
  final List<CategoryModel> categories;

  CategoryDeleteSuccess({required this.categories});
}

/// Error state
class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});
}
