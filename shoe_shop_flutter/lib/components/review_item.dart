import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../data/model/review_model.dart';
class ReviewItem extends StatelessWidget {
  final Review review;
  final double scaleFactor;

  const ReviewItem({
    Key? key,
    required this.review,
    this.scaleFactor = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int rating = review.rating;
    final String comment = review.comment ?? '';
    final String username = review.user?.username ?? 'Anonymous';
    final String profileImage = review.user?.profileImage ??
        'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_1280.png';
    final String createdAt = review.createdAt != null
        ? DateFormat('dd MMM yyyy').format(review.createdAt!)
        : '';

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h * scaleFactor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: profileImage,
              width: 32.w * scaleFactor,
              height: 32.w * scaleFactor,
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                width: 32.w * scaleFactor,
                height: 32.w * scaleFactor,
                child: Center(
                  child: SizedBox(
                    width: 16.w * scaleFactor,
                    height: 16.w * scaleFactor,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 16.w * scaleFactor,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 16.w * scaleFactor, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(width: 8.w * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 10.sp * scaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: AppColors.amber,
                          size: 12.w * scaleFactor,
                        );
                      }),
                    ),
                    if (createdAt.isNotEmpty)
                      Text(
                        createdAt,
                        style: TextStyle(
                          fontSize: 9.sp * scaleFactor,
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  comment,
                  style: TextStyle(fontSize: 10.sp * scaleFactor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
