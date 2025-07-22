import 'dart:async';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';

import '../model/product_detail_model.dart';
import '../model/product_model.dart';
import '../model/product_page_model.dart';
import '../repository/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;

  final StreamController<List<Product>> productStream = StreamController<List<Product>>.broadcast();
  final StreamController<int> totalPagesStream = StreamController<int>.broadcast();
  ProductDetail? productDetail;

  ProductViewModel({required this.repository});

  Future<void> loadProductData({
    required int page,
    int? categoryId,
    String? nameSearch,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      ProductPage? productPage = await repository.getProductList(
        page,
        categoryId: categoryId,
        nameSearch: nameSearch,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );


      if (productPage != null) {
        productStream.add(productPage.products);
        totalPagesStream.add(productPage.totalPages);
      } else {
        productStream.add([]);
        totalPagesStream.add(0);
      }
    } catch (error) {
      productStream.addError(error);
      totalPagesStream.addError(error);
    }
  }

  Future<ProductDetail?> loadProductDetail(int id) async {
    try {
      productDetail = await repository.getProductDetail(id);
      return productDetail;
    } catch (e) {
      productDetail = null;
      print('Error loading product detail: $e');
      return null;
    }
  }

  @override
  void dispose() {
    productStream.close();
    totalPagesStream.close();
    super.dispose();
  }
}
