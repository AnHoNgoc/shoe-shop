import '../model/cart_data_model.dart';
import '../source/cart_source.dart';

abstract class CartRepository {
  Future<CartData> getCartData();
  Future<void> incrementCartItem (int productId);
  Future<void> decrementCartItem (int productId);
  Future<void> deleteCartItem (int productId);
  Future<void> addCartItem (int productId);
}

class CartRepositoryImpl implements CartRepository {
  final CartSource _cartSource;

  CartRepositoryImpl(this._cartSource);

  @override
  Future<CartData> getCartData() async {
    try {
      CartData cartData = await _cartSource.getCartData();
      return cartData;
    } catch (e) {
      print('Error occurred while fetching cart data: $e');
      return CartData(items: [], totalAmount: 0); // fallback an toàn
    }
  }

  @override
  Future<void> incrementCartItem(int productId) async {
    try {
      await _cartSource.incrementCartItem(productId);
    } catch (e) {
      print('Error while incrementing cart item: $e');
    }
  }

  @override
  Future<void> decrementCartItem(int productId) async {
    try {
      await _cartSource.decrementCartItem(productId);
    } catch (e) {
      print('Error while incrementing cart item: $e');
    }
  }

  @override
  Future<void> deleteCartItem(int productId) async {
    try {
      await _cartSource.deleteCartItem(productId);
    } catch (e) {
      print('Error while deleting cart item: $e');
    }
  }
  @override
  Future<void> addCartItem(int productId) async {
    try {
      await _cartSource.addCartItem(productId);
    } catch (e) {
      rethrow; // Gửi lỗi lên ViewModel xử lý
    }
  }
}