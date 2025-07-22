import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';
import '../api/dio_client.dart';
import '../model/order_model.dart';

abstract class DataSource {
  Future<void> checkout(String address, String phoneNumber);
  Future<void> stripeCheckout(String address, String phoneNumber);
  Future<List<OrderModel>> getOrders();
}

class OrderSource implements DataSource {

  @override
  Future<List<OrderModel>> getOrders() async {
    try {

      final String url = '${AppConstants.getOrdersEndpoint}';

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

        print('📦 Response status: ${response.statusCode}');
        print('🌐 Checkout URL: $checkoutUrl');
        print('🔍 canLaunchUrl: ${await canLaunchUrl(Uri.parse(checkoutUrl))}');
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
}