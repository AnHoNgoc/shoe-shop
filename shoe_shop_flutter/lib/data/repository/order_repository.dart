

import '../model/order_model.dart';
import '../source/order_source.dart';

abstract interface class OrderRepository {
  Future<void> checkout(String address, String phoneNumber);
  Future<void> stripeCheckout(String address, String phoneNumber);

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

}