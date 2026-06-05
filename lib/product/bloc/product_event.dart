part of 'product_bloc.dart';

abstract class ProductEvent {}

/// Load semua products
class ProductLoadAll extends ProductEvent {}

/// Create product baru
class ProductCreate extends ProductEvent {
  final ProductModel product;
  ProductCreate({required this.product});
}

/// Update product
class ProductUpdate extends ProductEvent {
  final ProductModel product;
  ProductUpdate({required this.product});
}

/// Delete product
class ProductDelete extends ProductEvent {
  final int id;
  ProductDelete({required this.id});
}