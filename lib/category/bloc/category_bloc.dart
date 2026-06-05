import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/category_model.dart';
import '../repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc
    extends Bloc<
        CategoryEvent,
        CategoryState> {
  final CategoryRepository
      _repository;

  List<CategoryModel>
      _categories = [];

  CategoryBloc({
    CategoryRepository?
        repository,
  })  : _repository =
            repository ??
                CategoryRepository(),
        super(
          CategoryInitial(),
        ) {
    on<CategoryLoadAll>(
      _onLoadAll,
    );

    on<CategoryCreate>(
      _onCreate,
    );

    on<CategoryUpdate>(
      _onUpdate,
    );

    on<CategoryDelete>(
      _onDelete,
    );
  }

  /// ==========================
  /// LOAD ALL
  /// ==========================
  Future<void> _onLoadAll(
    CategoryLoadAll event,
    Emitter<CategoryState>
        emit,
  ) async {
    emit(
      CategoryLoading(),
    );

    try {
      _categories =
          await _repository
              .getCategories();

      emit(
        CategoryLoaded(
          categories:
              List.from(
            _categories,
          ),
        ),
      );
    } catch (e) {
      emit(
        CategoryError(
          message:
              e.toString(),
        ),
      );
    }
  }

  /// ==========================
  /// CREATE
  /// ==========================
  Future<void> _onCreate(
    CategoryCreate event,
    Emitter<CategoryState>
        emit,
  ) async {
    emit(
      CategoryLoading(),
    );

    try {
      await _repository
          .createCategory(
        name:
            event.name,
        description:
            event.description,
      );

      // refresh data
      _categories =
          await _repository
              .getCategories();

      emit(
        CategoryCreateSuccess(
          categories:
              List.from(
            _categories,
          ),
        ),
      );
    } catch (e) {
      emit(
        CategoryError(
          message:
              e.toString(),
        ),
      );
    }
  }

  /// ==========================
  /// UPDATE
  /// ==========================
  Future<void> _onUpdate(
    CategoryUpdate event,
    Emitter<CategoryState>
        emit,
  ) async {
    emit(
      CategoryLoading(),
    );

    try {
      await _repository
          .updateCategory(
        id: event.id,
        name:
            event.name,
        description:
            event.description,
      );

      // refresh data
      _categories =
          await _repository
              .getCategories();

      emit(
        CategoryUpdateSuccess(
          categories:
              List.from(
            _categories,
          ),
        ),
      );
    } catch (e) {
      emit(
        CategoryError(
          message:
              e.toString(),
        ),
      );
    }
  }

  /// ==========================
  /// DELETE
  /// ==========================
  Future<void> _onDelete(
    CategoryDelete event,
    Emitter<CategoryState>
        emit,
  ) async {
    emit(
      CategoryLoading(),
    );

    try {
      await _repository
          .deleteCategory(
        event.id,
      );

      _categories
          .removeWhere(
        (c) =>
            c.id ==
            event.id,
      );

      emit(
        CategoryDeleteSuccess(
          categories:
              List.from(
            _categories,
          ),
        ),
      );
    } catch (e) {
      emit(
        CategoryError(
          message:
              e.toString(),
        ),
      );
    }
  }
}