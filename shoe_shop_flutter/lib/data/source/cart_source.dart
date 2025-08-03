import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';
import '../api/dio_client.dart';
import '../model/cart_data_model.dart';

abstract class DataSource {
  Future<CartData> getCartData();
  Future<void> incrementCartItem (int productId);
  Future<void> decrementCartItem (int productId);
  Future<void> deleteCartItem (int productId);
  Future<void> addCartItem (int productId);
}

class CartSource implements DataSource {
  @override
  Future<CartData> getCartData() async {
    try {
      final dio = await DioClient.getDio();
      final response = await dio.get(AppConstants.getCartListEndpoint);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['EC'] == 0) {
          return CartData.fromJson(data['DT']);
        } else {
          print("Get cart list failed: ${data['EM']}");
          return CartData(items: [], totalAmount: 0);
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        return CartData(items: [], totalAmount: 0);
      }
    } catch (e) {
      print('Error fetching cart list: $e');
      return CartData(items: [], totalAmount: 0);
    }
  }

  @override
  Future<void> incrementCartItem(int productId) async {
    try {
      final String url = AppConstants.incrementCartItemEndpoint;

      final dio = await DioClient.getDio();

      final response = await dio.patch(
        url,
        data: {
          'productId': productId,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body['EC'] == 0) {
          print('Increment cart item successful');
        } else {
          print('Increment cart item failed: ${body['EM']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error increment cart item: $e');
    }
  }

  @override
  Future<void> decrementCartItem(int productId) async {
    try {
      final String url = AppConstants.decrementCartItemEndpoint;

      final dio = await DioClient.getDio();

      final response = await dio.patch(
        url,
        data: {
          'productId': productId,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body['EC'] == 0) {
          print('Decrement cart item successful');
        } else {
          print('Decrement cart item failed: ${body['EM']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error decrement cart item: $e');
    }
  }

  @override
  Future<void> deleteCartItem(int productId) async {
    try {
      final String url = AppConstants.deleteCartItemEndpoint;

      final dio = await DioClient.getDio();

      final response = await dio.delete(
        url,
        data: {
          'productId': productId,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body['EC'] == 0) {
          print('Delete cart item successful');
        } else {
          print('Delete cart item failed: ${body['EM']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error delete cart item: $e');
    }
  }

  @override
  Future<void> addCartItem(int productId) async {
    try {
      final dio = await DioClient.getDio();
      final response = await dio.post(
        AppConstants.addCartItemEndpoint,
        data: {'productId': productId},
      );

      final body = response.data;

      if (response.statusCode == 201 && body['EC'] == 0) {
        print('✅ Add cart item successful');
      } else {
        throw body['EM'] ?? 'Unknown error';
      }
    } on DioException catch (e) {
      final message = e.response?.data['EM'] ?? 'Network error or bad request';
      throw message;
    } catch (e) {
      throw e.toString();
    }
  }
}
