import '../../constants/app_constants.dart';
import '../api/dio_client.dart';

abstract class DataSource {
  Future<void> createReview(int productId,int rating, String comment);
}

class ReviewSource implements DataSource {

  @override
  Future<void> createReview(int productId, int rating, String comment) async {
    try {
      final String url = AppConstants.createReviewEndpoint;

      final dio = await DioClient.getDio();

      final response = await dio.post(
        url,
        data: {
          'productId': productId,
          'rating': rating,
          'comment': comment,
        },
      );

      if (response.statusCode == 201) {
        final body = response.data;
        if (body['EC'] == 0) {
          print('✅ Create review successful');
          return; // OK
        } else {
          throw Exception('⚠️ Server error: ${body['EM']}');
        }
      } else {
        throw Exception('⚠️ HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creating review: $e');
      rethrow;
    }
  }


}
