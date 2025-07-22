import 'package:shoe_shop_flutter/data/model/review_model.dart';

import 'category_model.dart';

class ProductDetail {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String image;
  final Category? category;
  final List<Review>? reviews;

  ProductDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.category,
    this.reviews,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: json['quantity'],
      image: json['image'],
      category: json['Category'] != null
          ? Category.fromJson(json['Category'])
          : null,
      reviews: json['Reviews'] != null
          ? List<Review>.from(json['Reviews'].map((r) => Review.fromJson(r)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
    'image': image,
    'category': category?.toJson(),
    'Reviews': reviews?.map((r) => r.toJson()).toList(),
  };

  @override
  String toString() {
    return 'ProductDetail(id: $id, name: $name, price: $price, quantity: $quantity, image: $image, category: $category, reviews: $reviews)';
  }
}
