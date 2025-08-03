import 'package:shoe_shop_flutter/data/model/product_detail_model.dart';
import '../model/product_page_model.dart';
import '../source/product_source.dart';

abstract interface class ProductRepository {
  Future<ProductPage?> getProductList(
      int page, {
        int? categoryId,
        String? nameSearch,
        double? minPrice,
        double? maxPrice,
      });
  Future<ProductDetail?> getProductDetail(int id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductSource _productSource;

  ProductRepositoryImpl(this._productSource);

  @override
  Future<ProductPage?> getProductList(
      int page, {
        int? categoryId,
        String? nameSearch,
        double? minPrice,
        double? maxPrice,
      }) async {
    try {
      ProductPage? productPage = await _productSource.getProductList(
        page,
        categoryId: categoryId,
        nameSearch: nameSearch,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

      return productPage;
    } catch (e) {
      print('Error occurred while fetching products: $e');
      return null;
    }
  }

  @override
  Future<ProductDetail?> getProductDetail(int id) async {
    try {
      return await _productSource.getProductDetail(id);
    } catch (e) {
      print('Error occurred while fetching product detail: $e');
      return null;
    }
  }
}