import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../data/model/category_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryList extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;
  final List<Category> categories;

  const CategoryList({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(child: Text("No categories available."));
    }

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = MediaQuery.of(context).size.height;
    final itemHeight = isLandscape ? screenHeight * 0.25 : screenHeight * 0.15;

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelect(index),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              width: 80.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: itemHeight * 0.32,
                    width: itemHeight * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl: category.image,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                      fadeInDuration: const Duration(milliseconds: 300),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isSelected ? AppColors.black : AppColors.black45,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 3.h,
                    width: 40.w,
                    color: isSelected ? AppColors.black : AppColors.transparent,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
