import 'package:shoe_shop_flutter/data/model/category_model.dart';
import 'package:shoe_shop_flutter/data/source/category_source.dart';



abstract interface class CategoryRepository {
  Future<List<Category>> getCategoryList();
}

class CategoryRepositoryImpl implements CategoryRepository {

  final CategorySource _categorySource;

  CategoryRepositoryImpl(this._categorySource);
  @override
  Future<List<Category>> getCategoryList() async {
    try {
      List<Category>? remoteCategories = await _categorySource.getCategories();
      return remoteCategories ?? [];
    } catch (e) {
      print('Error occurred while fetching categories: $e');
      return [];
    }
  }
}