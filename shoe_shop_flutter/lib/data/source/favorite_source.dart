import '../../constants/app_constants.dart';
import '../api/dio_client.dart';
import '../model/favorite_model.dart';


abstract class DataSource {
  Future<void> toggleFavorite(int productId);
  Future<List<FavoriteItem>> getFavorites();
}

class FavoriteSource implements DataSource {

  @override
  Future<void> toggleFavorite( int productId) async {
    try {
      final String url = '${AppConstants.toggleFavoriteEndpoint}';

      final dio = await DioClient.getDio();

      final response = await dio.post(
        url,
        data: {
          'productId': productId,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body['EC'] == 0) {
          print('Toggle favorite successful');
        } else {
          print('Toggle favorite failed: ${body['EM']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }


  @override
  Future<List<FavoriteItem>> getFavorites() async {
    try {
      final String url = '${AppConstants.getFavoritesEndpoint}';

      final dio = await DioClient.getDio();
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['EC'] == 0) {
          List<dynamic> favoritesList = data['DT'];
          return favoritesList.map((item) => FavoriteItem.fromMap(item)).toList();
        } else {
          print("Get favorites failed: ${data['EM']}");
          return [];
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

}