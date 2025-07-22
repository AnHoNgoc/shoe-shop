import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileInfo extends StatelessWidget {
  final IconData icon;
  final String name;

  const ProfileInfo({super.key, required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 35.sp,
                color: Colors.black.withOpacity(0.7),
              ),
              SizedBox(width: 20.w),
              Text(
                name,
                style: TextStyle(fontSize: 17.sp),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 20.sp),
            ],
          ),
          SizedBox(height: 12.h),  // vertical spacing
          Divider(color: Colors.black12, thickness: 1.h),
        ],
      ),
    );
  }
}