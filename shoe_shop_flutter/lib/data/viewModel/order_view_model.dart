import 'package:flutter/cupertino.dart';
import 'package:shoe_shop_flutter/data/model/order_model.dart';
import 'package:shoe_shop_flutter/data/model/order_page_model.dart';

import '../repository/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository;

  List<OrderModel> _orderListByUser = [];
  List<OrderModel> get orderListByUser => _orderListByUser;

  OrderPageModel? _orderPageModel ;
  OrderPageModel? get orderPageModel => _orderPageModel;

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

  Future<void> fetchOrdersByUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orderListByUser = await _repository.getOrders();
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrders({
    required int page,
    String? status,
    String sort = 'desc'
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orderPageModel = await _repository.getOrderList(page, status: status, sort: sort);
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
  Future<void> updateStatus(int orderId, String status) async {
    try {
      await _repository.updateStatus(orderId, status);
      print('✅ Order $orderId updated to $status');
    } catch (e) {
      print('❌ Failed to update order status: $e');
      rethrow; // Nếu bạn muốn xử lý lỗi ở UI
    }
  }
}