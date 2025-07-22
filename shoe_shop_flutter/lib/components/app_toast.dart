import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppToast {
  static void showSuccess(String message) {
    _show(message, AppColors.green);
  }

  static void showError(String message) {
    _show(message, AppColors.redAccent);
  }

  static void _show(String message, Color bgColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: AppColors.white,
      fontSize: 16.0,
    );
  }
}