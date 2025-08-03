import 'package:shoe_shop_flutter/data/model/order_model.dart';

class OrderPageModel {
  final List<OrderModel> orders;
  final int totalPages;

  OrderPageModel({
    required this.orders,
    required this.totalPages,
  });
}