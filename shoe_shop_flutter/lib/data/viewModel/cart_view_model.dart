import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../model/cart_item_model.dart';
import '../repository/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _repository;

  List<CartItem> _cartList = [];
  double _totalAmount = 0;

  List<CartItem> get cartList => _cartList;
  double get totalAmount => _totalAmount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CartViewModel(this._repository);

  Future<void> fetchCart() async {
    try {
      _isLoading = true;
      notifyListeners();

      final cartData = await _repository.getCartData();
      _cartList = cartData.items;
      _totalAmount = cartData.totalAmount;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> incrementCartItem(int productId) async {
    try {
      await _repository.incrementCartItem(productId);
      await fetchCart();
    } catch (e) {
      print('Error while incrementing item: $e');
      notifyListeners();
    }
  }

  Future<void> decrementCartItem(int productId) async {
    try {
      await _repository.decrementCartItem(productId);
      await fetchCart();
    } catch (e) {
      print('Error while incrementing item: $e');
      notifyListeners();
    }
  }

  Future<void> deleteCartItem(int productId) async {
    try {
      await _repository.deleteCartItem(productId);
      await fetchCart();
      notifyListeners();
    } catch (e) {
      print('Error while deleting item: $e');
      notifyListeners();
    }
  }

  Future<void> addCartItem(int productId) async {
    try {
      await _repository.addCartItem(productId);
      await fetchCart();
      notifyListeners();
    } on DioException catch (e) {
      final errorMessage = e.response?.data['EM'] ?? 'Unknown error';
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  int getQuantityInCart(int productId) {
    for (final item in _cartList) {
      if (item.productId == productId) {
        return item.quantity;
      }
    }
    return 0;
  }

  void clearCart() {
    _cartList.clear();
    notifyListeners();
  }
}