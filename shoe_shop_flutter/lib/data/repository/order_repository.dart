

import '../model/order_model.dart';
import '../model/order_page_model.dart';
import '../source/order_source.dart';

abstract interface class OrderRepository {
  Future<void> checkout(String address, String phoneNumber);
  Future<void> stripeCheckout(String address, String phoneNumber);
  Future<OrderPageModel?> getOrderList(int page, { String? status, String sort = 'desc'});
  Future<void> updateStatus (int orderId ,String status);
  Future<List<OrderModel>> getOrders();
}

class OrderRepositoryImpl implements OrderRepository {

  final OrderSource _orderSource;

  OrderRepositoryImpl(this._orderSource);

  @override
  Future<void> checkout(String address, String phoneNumber) async {
    try {
      await _orderSource.checkout(address, phoneNumber);
    } catch (e) {
      print('An error occurred while checking out: $e');
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getOrders()  async{
    try {
      List<OrderModel> orders = await _orderSource.getOrders();
      return orders;
    } catch (e) {
      print('Error occurred while fetching favorite list: $e');
      return [];
    }
  }

  @override
  Future<void> stripeCheckout(String address, String phoneNumber) async {
    try {
      await _orderSource.stripeCheckout(address, phoneNumber);
    } catch (e) {
      print('An error occurred while checking out: $e');
      rethrow;
    }
  }

  @override
  Future<OrderPageModel?> getOrderList(int page, {String? status, String sort = 'desc'}) async {
    try {
      OrderPageModel? orderPageModel = await _orderSource.getOrderList(page, status: status, sort: sort);
      return orderPageModel;
    } catch (e) {
      print('Error occurred while fetching products: $e');
      return null;
    }
  }

  @override
  Future<void> updateStatus(int orderId, String status) async{
    try {
      await _orderSource.updateStatus(orderId, status);
    } catch (e) {
      print('An error occurred while update: $e');
      rethrow;
    }
  }
}