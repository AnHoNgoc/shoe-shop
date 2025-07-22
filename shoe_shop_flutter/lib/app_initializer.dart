import 'package:flutter/cupertino.dart';
import 'package:shoe_shop_flutter/utils/deeplink_handle.dart';

// class AppInitializer extends StatefulWidget {
//   final Widget child;
//
//   const AppInitializer({super.key, required this.child});
//
//   @override
//   State<AppInitializer> createState() => _AppInitializerState();
// }
//
// class _AppInitializerState extends State<AppInitializer> {
//   final DeepLinkHandler _deepLinkHandler = DeepLinkHandler();
//
//   @override
//   void initState() {
//     super.initState();
//     // Gọi deeplink handler ở đây vì context đã sẵn sàng
//     // Trì hoãn deeplink xử lý sau khi widget tree đã ổn định
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await Future.delayed(const Duration(milliseconds: 500)); // thêm delay
//       _deepLinkHandler.init(context: context);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }