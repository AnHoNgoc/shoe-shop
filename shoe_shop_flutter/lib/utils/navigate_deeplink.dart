import 'package:flutter/cupertino.dart';

import '../components/app_toast.dart';
import '../main.dart';

class NavigationUtil {
  static void navigateAndNotify({
    required String routeName,
    required String message,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    Navigator.pushNamedAndRemoveUntil(context, routeName, (_) => false);
    AppToast.showSuccess(message);
  }
}