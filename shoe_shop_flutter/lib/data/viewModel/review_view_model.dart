import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shoe_shop_flutter/data/repository/review_repository.dart';

class ReviewViewModel extends ChangeNotifier {
  final ReviewRepository _repository;

  ReviewViewModel(this._repository);

  Future<void> createReview(int productId, int rating, String comment) async {
    try {
      await _repository.createReview(productId, rating, comment);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['EM'] ?? 'Unknown error';
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }
}