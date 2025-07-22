class ProductOrder {
  final String name;
  final double price;
  final int quantity;

  ProductOrder({
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price.toStringAsFixed(2),
      'quantity': quantity,
    };
  }
}