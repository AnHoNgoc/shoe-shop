import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'navigate_deeplink.dart';


class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();
  bool _isHandling = false;

  Future<void> init() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
      _appLinks.uriLinkStream.listen((uri) {
        _handleUri(uri);
      });
    } catch (e) {
      debugPrint('[DeepLinkHandler] Error: $e');
    }
  }

  void _handleUri(Uri uri) {
    if (_isHandling) return;
    _isHandling = true;

    final path = uri.host;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (path) {
        case 'checkout-success':
          NavigationUtil.navigateAndNotify(
            routeName: AppRoutes.main,
            message: 'Payment successful 🎉',
          );
          break;
        case 'checkout-cancel':
          NavigationUtil.navigateAndNotify(
            routeName: AppRoutes.main,
            message: 'Payment failed ❌',
          );
          break;
        default:
          debugPrint('[DeepLinkHandler] Unknown path: $path');
      }
      _isHandling = false;
    });
  }
}
