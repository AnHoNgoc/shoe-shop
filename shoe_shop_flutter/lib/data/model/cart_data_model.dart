import 'cart_item_model.dart';

class CartData {
  final List<CartItem> items;
  final double totalAmount;

  CartData({
    required this.items,
    required this.totalAmount,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}