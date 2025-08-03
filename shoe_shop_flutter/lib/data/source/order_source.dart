import 'package:shoe_shop_flutter/data/model/order_page_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';
import '../api/dio_client.dart';
import '../model/order_model.dart';

abstract class DataSource {
  Future<void> checkout(String address, String phoneNumber);
  Future<void> stripeCheckout(String address, String phoneNumber);
  Future<List<OrderModel>> getOrders();
  Future<OrderPageModel?> getOrderList(int page, { String? status, String sort = 'desc'});
  Future<void> updateStatus (int orderId ,String status);
}

class OrderSource implements DataSource {

  @override
  Future<List<OrderModel>> getOrders() async {
    try {

      final String url = AppConstants.getOrdersByUserEndpoint;

      final dio = await DioClient.getDio();
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['EC'] == 0) {
          List<dynamic> orderList = data['DT'];
          return orderList.map((item) => OrderModel.fromJson(item)).toList();
        } else {
          print("Get orders failed: ${data['EM']}");
          return [];
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  @override
  Future<void> checkout(String address, String phoneNumber) async {
    try {
      final String url = AppConstants.checkoutEndpoint;

      final dio = await DioClient.getDio();

      final response = await dio.post(
        url,
        data: {
          'address': address,
          'phoneNumber': phoneNumber,
        },
      );

      if (response.statusCode == 201) {
        final body = response.data;
        if (body['EC'] == 0) {
          print('✅ Checkout successful');
          return;
        } else {
          throw Exception('⚠️ Server error: ${body['EM']}');
        }
      } else {
        throw Exception('⚠️ HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Checkout error: $e');
      rethrow;
    }
  }

  @override
  Future<void> stripeCheckout(String address, String phoneNumber) async {
    try {
      final String url = AppConstants.stripeEndpoint;
      final dio = await DioClient.getDio();

      final response = await dio.post(
        url,
        data: {
          'address': address,
          'phoneNumber': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;

        final checkoutUrl = body['url'];

        if (checkoutUrl == null) {
          throw Exception('❌ Response missing "url"');
        }
        print('✅ Opening Stripe Checkout...');
        if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
          await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
        } else {
          throw Exception('❌ Could not launch Stripe checkout URL');
        }
      } else {
        throw Exception('⚠️ HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Checkout error: $e');
      rethrow;
    }
  }

  @override
  Future<OrderPageModel?> getOrderList(
      int page, {
        String? status,
        String sort = 'desc',
      }) async {
    try {
      final String url = AppConstants.getOrdersEndpoint;

      final dio = await DioClient.getDio();

      // Xây dựng query parameters
      final queryParams = {
        'page': page,
        if (status != null) 'status': status,
        if (sort.isNotEmpty) 'sort': sort,
      };

      // Gửi request GET
      final response = await dio.get(url, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final data = response.data;

        final orderListJson = data['DT']['orders'] as List;
        final int totalPages = data['DT']['totalPages'];

        final orders = orderListJson
            .map((json) => OrderModel.fromJson(json))
            .toList();

        return OrderPageModel(orders: orders, totalPages: totalPages);
      } else {
        print('Failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching order list: $e');
      return null;
    }
  }

  @override
  Future<void> updateStatus(int orderId, String status) async {
    try {
      final String url = '${AppConstants.baseUrl}${AppConstants.updateStatusEndpoint}/$orderId';

      final dio = await DioClient.getDio();

      final response = await dio.patch(
        url,
        data: {
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body['EC'] == 0) {
          print('✅ Order #$orderId status updated to: $status');
          return;
        } else {
          throw Exception('⚠️ Server error: ${body['EM']}');
        }
      } else {
        throw Exception('⚠️ HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Update status error: $e');
      rethrow;
    }
  }
}