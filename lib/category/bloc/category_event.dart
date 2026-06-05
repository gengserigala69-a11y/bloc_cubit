part of 'category_bloc.dart';

abstract class CategoryEvent {}

/// Load semua categories
class CategoryLoadAll extends CategoryEvent {}

/// Create category baru
class CategoryCreate extends CategoryEvent {
  final String name;
  final String description;

  CategoryCreate({required this.name, required this.description});
}

/// Update category
class CategoryUpdate extends CategoryEvent {
  final int id;
  final String name;
  final String description;

  CategoryUpdate({
    required this.id,
    required this.name,
    required this.description,
  });
}

/// Delete category
class CategoryDelete extends CategoryEvent {
  final int id;

  CategoryDelete({required this.id});
}
