

import 'package:shoe_shop_flutter/data/source/review_source.dart';

abstract interface class ReviewRepository {
  Future<void> createReview(int productId,int rating, String comment);

}

class ReviewRepositoryImpl implements ReviewRepository {

  final ReviewSource _reviewSource;

  ReviewRepositoryImpl(this._reviewSource);

  @override
  Future<void> createReview(int productId, int rating, String comment) async {
    try {
      await _reviewSource.createReview(productId, rating, comment);
    } catch (e) {
      print('Error occurred while creating review: $e');
      rethrow; // 🔥 Ném lỗi lại để ViewModel xử lý
    }
  }

}