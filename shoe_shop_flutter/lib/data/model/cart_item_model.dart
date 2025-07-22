class CartItem {
  final int productId;
  final int quantity;
  final double price;
  final String name;
  final String image;
  final String categoryName;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.name,
    required this.image,
    required this.categoryName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      name: json['name'],
      image: json['image'],
      categoryName: json['categoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'name': name,
      'image': image,
      'categoryName': categoryName,
    };
  }

  @override
  String toString() {
    return 'CartItem(productId: $productId, quantity: $quantity, price: $price, '
        'name: "$name", image: "$image", categoryName: "$categoryName")';
  }
}