import 'package:shoe_shop_flutter/data/model/product_model.dart';

class ProductPage {
  final List<Product> products;
  final int totalPages;

  ProductPage({
    required this.products,
    required this.totalPages,
  });
}