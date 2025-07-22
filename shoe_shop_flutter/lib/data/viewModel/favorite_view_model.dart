import 'package:flutter/material.dart';
import '../model/favorite_model.dart';
import '../repository/favorite_repository.dart';

class FavoriteViewModel extends ChangeNotifier {
  final FavoriteRepository _repository;

  List<FavoriteItem> _favoriteList = [];
  List<FavoriteItem> get favoriteList => _favoriteList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FavoriteViewModel(this._repository);

  Future<void> fetchFavorites() async {
    try {
      _isLoading = true;
      notifyListeners();

      _favoriteList = await _repository.getFavoriteList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching favorites: $e');
      _isLoading = false;
      notifyListeners();

    }
  }


  Future<void> toggleFavorite(int productId) async {
    try {
      await _repository.toggleFavorite(productId);
      await fetchFavorites();
    } catch (e) {
      print('Error toggling favorite: $e');

    }
  }

  bool isFavorite(int productId) {
    return _favoriteList.any(
          (item) => item.productId == productId && item.isFavorite == true,
    );
  }

  void clearFavorites() {
    _favoriteList = [];
    _isLoading = false;
    notifyListeners();
  }
}
