class Product {
  int id;
  String name;
  double price;  // Thay `DECIMAL` bằng `double` trong Dart
  int quantity;
  String image;
  int categoryId;  // Mối quan hệ với Category thông qua categoryId

  // Constructor
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.categoryId,
  });


  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      price: double.tryParse(map['price'].toString()) ?? 0.0,
      quantity: map['quantity'] as int,
      image: map['image'] as String,
      categoryId: map['category_id'] as int,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
      'category_id': categoryId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, quantity: $quantity, image: $image, categoryId: $categoryId}';
  }
}