import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  List<ProductModel> _products = [];

  ProductBloc({ProductRepository? repository})
      : _repository = repository ?? ProductRepository(),
        super(ProductInitial()) {
    on<ProductLoadAll>(_onLoadAll);
    on<ProductCreate>(_onCreate);
    on<ProductUpdate>(_onUpdate);
    on<ProductDelete>(_onDelete);
  }

  // ==========================
  // LOAD ALL
  // ==========================
  Future<void> _onLoadAll(
    ProductLoadAll event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      _products = await _repository.getProducts();
      emit(ProductLoaded(products: List.from(_products)));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  // ==========================
  // CREATE
  // ==========================
  Future<void> _onCreate(
    ProductCreate event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _repository.createProduct(event.product);
      _products = await _repository.getProducts();
      emit(ProductCreateSuccess(products: List.from(_products)));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  // ==========================
  // UPDATE
  // ==========================
  Future<void> _onUpdate(
    ProductUpdate event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _repository.updateProduct(event.product);
      _products = await _repository.getProducts();
      emit(ProductUpdateSuccess(products: List.from(_products)));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  // ==========================
  // DELETE
  // ==========================
  Future<void> _onDelete(
    ProductDelete event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _repository.deleteProduct(event.id);
      // Optimistic: hapus dari cache lokal
      _products.removeWhere((p) => p.id == event.id);
      emit(ProductDeleteSuccess(products: List.from(_products)));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}