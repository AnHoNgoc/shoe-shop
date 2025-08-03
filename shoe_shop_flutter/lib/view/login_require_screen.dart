import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../data/viewModel/auth_view_model.dart';
import '../routes/app_routes.dart';

class RequireLoginScreen extends StatelessWidget {
  const RequireLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();

    if (!authViewModel.isLoggedIn) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80.w,
                  color: AppColors.deepPurpleAccent,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Access Denied",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  "You must be logged in to access this page.",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: 160.w,
                  height: 48.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    icon: Icon(Icons.login, size: 20.sp),
                    label: Text(
                      "Login",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepPurpleAccent,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: TextStyle(fontSize: 20.sp, color: AppColors.white),
        ),
        backgroundColor: AppColors.deepPurpleAccent,
      ),
      body: Center(
        child: Text(
          "Logged in",
          style: TextStyle(fontSize: 16.sp, color: AppColors.black87),
        ),
      ),
    );
  }
}
