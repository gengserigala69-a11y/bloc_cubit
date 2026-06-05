part of 'product_bloc.dart';

abstract class ProductState {}

/// Initial state
class ProductInitial extends ProductState {}

/// Loading state
class ProductLoading extends ProductState {}

/// Success load list
class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded({required this.products});
}

/// Success create
class ProductCreateSuccess extends ProductState {
  final List<ProductModel> products;
  ProductCreateSuccess({required this.products});
}

/// Success update
class ProductUpdateSuccess extends ProductState {
  final List<ProductModel> products;
  ProductUpdateSuccess({required this.products});
}

/// Success delete
class ProductDeleteSuccess extends ProductState {
  final List<ProductModel> products;
  ProductDeleteSuccess({required this.products});
}

/// Error state
class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});
}