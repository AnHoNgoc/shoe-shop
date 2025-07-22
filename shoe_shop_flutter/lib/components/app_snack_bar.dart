import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    _show(context, 'Success', message, ContentType.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, 'Error', message, ContentType.failure);
  }

  static void _show(
      BuildContext context,
      String title,
      String message,
      ContentType contentType,
      ) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}