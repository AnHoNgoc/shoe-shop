import 'dart:convert';
import 'dart:ffi';
import "package:http/http.dart" as http;
import 'package:shoe_shop_flutter/data/model/product_detail_model.dart';
import '../../constants/app_constants.dart';
import '../model/product_model.dart';
import '../model/product_page_model.dart';

abstract class DataSource {
  Future<ProductPage?> getProductList(
      int page, {
        int? categoryId,
        String? nameSearch,
        double? minPrice,
        double? maxPrice,
      });

  Future<ProductDetail?> getProductDetail(int id);
}
class ProductSource implements DataSource {

  @override
  Future<ProductPage?> getProductList(
      int page, {
        int? categoryId,
        String? nameSearch,
        double? minPrice,
        double? maxPrice,
      }) async {
    try {
      String url = '${AppConstants.baseUrl}${AppConstants.productListEndpoint}?page=$page';

      if (categoryId != null && categoryId != 1) {
        url += '&idCategory=$categoryId';
      }
      if (nameSearch != null && nameSearch.isNotEmpty) {
        url += '&nameSearch=$nameSearch';
      }
      if (minPrice != null) {
        url += '&minPrice=$minPrice';
      }
      if (maxPrice != null) {
        url += '&maxPrice=$maxPrice';
      }

      final uri = Uri.parse(url);
      final rs = await http.get(uri);

      if (rs.statusCode == 200) {
        final bodyContent = utf8.decode(rs.bodyBytes);
        var productWrapper = jsonDecode(bodyContent) as Map;

        var productList = productWrapper['DT']['products'] as List;
        int totalPages = productWrapper['DT']['totalPages'];

        List<Product> products =
        productList.map((product) => Product.fromJson(product)).toList();

        return ProductPage(products: products, totalPages: totalPages);
      } else {
        print('Failed to load products with status code: ${rs.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

  @override
  Future<ProductDetail?> getProductDetail(int id) async {
    try {
      final String url =
          '${AppConstants.baseUrl}${AppConstants.productDetailEndpoint}$id';
      final uri = Uri.parse(url);
      final rs = await http.get(uri);

      if (rs.statusCode == 200) {
        final bodyContent = utf8.decode(rs.bodyBytes);
        final Map<String, dynamic> jsonMap = jsonDecode(bodyContent);

        if (jsonMap['EC'] == 0 && jsonMap['DT'] != null) {
          print(' ${jsonMap['DT']}');
          return ProductDetail.fromJson(jsonMap['DT']);
        } else {
          print('Product not found or error from server: ${jsonMap['EM']}');
          return null;
        }
      } else {
        print('Failed to fetch product detail. Status code: ${rs.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception occurred while fetching product detail: $e');
      return null;
    }
  }
}