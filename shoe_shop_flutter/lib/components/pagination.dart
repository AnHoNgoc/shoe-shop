import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<Widget> _buildPageButtons() {
    List<Widget> buttons = [];

    void addPage(int page) {
      buttons.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: TextButton(
            onPressed: () => onPageChanged(page),
            style: TextButton.styleFrom(
              backgroundColor:
              currentPage == page ? AppColors.blue : AppColors.transparent,
              foregroundColor:
              currentPage == page ? AppColors.white : AppColors.black,
              minimumSize: Size(30.w, 30.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            ),
            child: Text(
              '$page',
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
        ),
      );
    }

    void addEllipsis() {
      buttons.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            '...',
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
      );
    }

    if (totalPages <= 6) {
      for (int i = 1; i <= totalPages; i++) {
        addPage(i);
      }
    } else {
      addPage(1);

      if (currentPage > 3) addEllipsis();

      int start = currentPage - 1;
      int end = currentPage + 1;

      if (start <= 1) start = 2;
      if (end >= totalPages) end = totalPages - 1;

      for (int i = start; i <= end; i++) {
        addPage(i);
      }

      if (currentPage < totalPages - 2) addEllipsis();

      addPage(totalPages);
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left, size: 24.sp),
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          ..._buildPageButtons(),
          IconButton(
            icon: Icon(Icons.arrow_right, size: 24.sp),
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}