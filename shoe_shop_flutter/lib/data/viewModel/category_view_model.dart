import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:shoe_shop_flutter/data/model/category_model.dart';
import 'package:shoe_shop_flutter/data/repository/category_repository.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryRepository repository;

  CategoryViewModel({required this.repository});

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Future<void> loadCategories() async {
    try {
      _categories = await repository.getCategoryList();
      notifyListeners();
    } catch (e) {
      print("Get category list failed: $e");
    }
  }
}