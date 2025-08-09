import 'package:shoe_shop_flutter/data/model/user_model.dart';

class Review {
  final int rating;
  final String? comment;
  final DateTime? createdAt;
  final User? user;

  Review({
    required this.rating,
    this.comment,
    this.createdAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      user: json['User'] != null ? User.fromJson(json['User']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'created_at': createdAt?.toIso8601String(),
      'User': user?.toJson(),
    };
  }

  @override
  String toString() {
    return 'Review(rating: $rating, comment: $comment, createdAt: $createdAt, user: $user)';
  }
}
