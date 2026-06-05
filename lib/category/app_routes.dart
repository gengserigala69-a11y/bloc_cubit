import 'package:flutter/material.dart';

import 'package:bloc_cubit/category/view/category_view.dart';
import 'package:bloc_cubit/category/view/add_category_page.dart';
import 'package:bloc_cubit/category/view/edit_category_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get categoryRoutes => {
        '/category': (_) => const CategoryView(),
        '/add-category': (_) => const AddCategoryPage(),
        '/edit-category': (_) => const EditCategoryPage(),
      };
}