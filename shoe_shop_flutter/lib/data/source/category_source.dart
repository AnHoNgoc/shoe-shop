import 'dart:convert';
import '../../constants/app_constants.dart';
import '../model/category_model.dart';
import "package:http/http.dart" as http;

abstract  class DataSource {
  Future<List<Category>?> getCategories();
}

class CategorySource implements DataSource {

  @override
  Future<List<Category>?> getCategories() async {
    try {
      final String url = '${AppConstants.baseUrl}${AppConstants.categoryListEndpoint}';
      final uri = Uri.parse(url);
      final rs = await http.get(uri);

      if (rs.statusCode == 200) {
        final bodyContent = utf8.decode(rs.bodyBytes);
        var categoryWrapper = jsonDecode(bodyContent) as Map;
        var categoryList = categoryWrapper['DT'] as List;

        List<Category> categories = categoryList.map((category) => Category.fromJson(category)).toList();
        return categories;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return null;
    }
  }
}
