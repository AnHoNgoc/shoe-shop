import '../model/favorite_model.dart';
import '../source/favorite_source.dart';

abstract interface class FavoriteRepository {

  Future<void> toggleFavorite( int productId);
  Future<List<FavoriteItem>> getFavoriteList();
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteSource _favoriteSource;

  FavoriteRepositoryImpl(this._favoriteSource);

  @override
  Future<void> toggleFavorite(int productId) async {
    try {
        await _favoriteSource.toggleFavorite( productId);
    } catch (e) {
      print('Error occurred while toggling favorite: $e');
    }
  }

  @override
  Future<List<FavoriteItem>> getFavoriteList() async {
    try {
        List<FavoriteItem> favorites = await _favoriteSource.getFavorites();
        return favorites;
    } catch (e) {
      print('Error occurred while fetching favorite list: $e');
      return [];
    }
  }
}