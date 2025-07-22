import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class SearchBarAndFilter extends StatefulWidget {
  final Function(String nameSearch, double minPrice, double maxPrice)? onSearch;

  const SearchBarAndFilter({super.key, this.onSearch});

  @override
  State<SearchBarAndFilter> createState() => _SearchBarAndFilterState();
}

class _SearchBarAndFilterState extends State<SearchBarAndFilter> {
  final TextEditingController _searchController = TextEditingController();
  RangeValues _currentRangeValues = const RangeValues(0, 1000);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showSearchAndFilterBottomSheet(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7.r,
                      color: AppColors.black38,
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 24.sp, color: AppColors.black),
                      SizedBox(width: 8.w),
                      Text(
                        "Find product",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              _showSearchAndFilterBottomSheet(context);
            },
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.black54, width: 1.w),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.tune, size: 24.sp, color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchAndFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16.w,
                right: 16.w,
                top: 16.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        hintText: 'Enter product name',
                        hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.black54),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Price Range: \$ ${_currentRangeValues.start.toInt()} - ${_currentRangeValues.end.toInt()}',
                      style: TextStyle(fontSize: 16.sp, color: AppColors.black),
                    ),
                    RangeSlider(
                      values: _currentRangeValues,
                      min: 0,
                      max: 5000,
                      divisions: 100,
                      labels: RangeLabels(
                        _currentRangeValues.start.round().toString(),
                        _currentRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setStateBottomSheet(() {
                          _currentRangeValues = values;
                        });
                      },
                      activeColor: AppColors.black,
                      inactiveColor: AppColors.black54,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 14.sp, color: AppColors.black54),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final nameSearch = _searchController.text.trim();
                            widget.onSearch?.call(
                              nameSearch,
                              _currentRangeValues.start,
                              _currentRangeValues.end,
                            );
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Search',
                            style: TextStyle(fontSize: 14.sp, color: AppColors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}