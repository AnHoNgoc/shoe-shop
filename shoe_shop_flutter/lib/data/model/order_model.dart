import 'package:shoe_shop_flutter/data/model/product_order.dart';
import 'package:shoe_shop_flutter/data/model/user_model.dart';

class OrderModel {
  final int id;
  final String status;
  final String address;
  final String phoneNumber;
  final double totalAmount;
  final DateTime createdAt;
  final List<ProductOrder> products;
  final User? user;

  OrderModel({
    required this.id,
    required this.status,
    required this.address,
    required this.phoneNumber,
    required this.totalAmount,
    required this.createdAt,
    required this.products,
    this.user,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      status: json['status'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
      products: (json['products'] as List<dynamic>)
          .map((item) => ProductOrder.fromJson(item))
          .toList(),
      user: json['user'] != null ? User.fromJson(json['user']) : null, // 👈 parse user
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'address': address,
      'phone_number': phoneNumber,
      'total_amount': totalAmount.toStringAsFixed(2),
      'created_at': createdAt.toIso8601String(),
      'products': products.map((product) => product.toJson()).toList(),
      'user': user?.toJson(), // 👈 optional user
    };
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, status: $status, address: $address, '
        'phoneNumber: $phoneNumber, totalAmount: $totalAmount, '
        'createdAt: $createdAt, products: $products, user: $user)';
  }
}