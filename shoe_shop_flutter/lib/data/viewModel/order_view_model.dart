import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shoe_shop_flutter/data/model/order_model.dart';

import '../repository/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository;

  List<OrderModel> _orderList = [];
  List<OrderModel> get orderList => _orderList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OrderViewModel(this._repository);

  Future<void> checkout(String address, String phoneNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.checkout(address, phoneNumber);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orderList = await _repository.getOrders();
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> stripeCheckout(String address, String phoneNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.stripeCheckout(address, phoneNumber);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}