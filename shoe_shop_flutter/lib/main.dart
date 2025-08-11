import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shoe_shop_flutter/data/source/favorite_source.dart';
import 'package:shoe_shop_flutter/routes/app_routes.dart';
import 'package:shoe_shop_flutter/utils/deeplink_handle.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/cart_repository.dart';
import 'data/repository/category_repository.dart';
import 'data/repository/favorite_repository.dart';
import 'data/repository/order_repository.dart';
import 'data/repository/product_repository.dart';
import 'data/repository/review_repository.dart';
import 'data/repository/user_repository.dart';
import 'data/source/auth_source.dart';
import 'data/source/cart_source.dart';
import 'data/source/category_source.dart';
import 'data/source/order_source.dart';
import 'data/source/product_source.dart';
import 'data/source/review_source.dart';
import 'data/source/user_source.dart';
import 'data/viewModel/auth_view_model.dart';
import 'data/viewModel/cart_view_model.dart';
import 'data/viewModel/category_view_model.dart';
import 'data/viewModel/favorite_view_model.dart';
import 'data/viewModel/order_view_model.dart';
import 'data/viewModel/product_view_model.dart';
import 'data/viewModel/review_view_model.dart';
import 'data/viewModel/user_view_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkHandler().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth
        Provider<AuthSource>(create: (_) => AuthSource()),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(context.read<AuthSource>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
        ),

        // Favorite
        Provider<FavoriteSource>(create: (_) => FavoriteSource()),
        Provider<FavoriteRepository>(
          create: (context) => FavoriteRepositoryImpl(context.read<FavoriteSource>()),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteViewModel(context.read<FavoriteRepository>()),
        ),
        //User
        Provider<UserSource>(create: (_) => UserSource()),
        Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(context.read<UserSource>()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(context.read<UserRepository>()),
        ),

        Provider<ReviewSource>(create: (_) => ReviewSource()),
        Provider<ReviewRepository>(
          create: (context) => ReviewRepositoryImpl(context.read<ReviewSource>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewViewModel(context.read<ReviewRepository>()),
        ),

        Provider<ProductSource>(create: (_) => ProductSource()),
        Provider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(context.read<ProductSource>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductViewModel(repository: context.read<ProductRepository>()),
        ),

        Provider<CategorySource>(create: (_) => CategorySource()),
        Provider<CategoryRepository>(
          create: (context) => CategoryRepositoryImpl(context.read<CategorySource>()),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryViewModel(repository: context.read<CategoryRepository>()),
        ),

        Provider<CartSource>(create: (_) => CartSource()),
        Provider<CartRepository>(
          create: (context) => CartRepositoryImpl(context.read<CartSource>()),
        ),
        ChangeNotifierProvider(
          create: (context) => CartViewModel(context.read<CartRepository>()),
        ),
        Provider<OrderSource>(create: (_) => OrderSource()),
        Provider<OrderRepository>(
          create: (context) => OrderRepositoryImpl(context.read<OrderSource>()),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderViewModel(context.read<OrderRepository>()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(411, 866),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            initialRoute: AppRoutes.main,
            routes: AppRoutes.routes,
            builder: (context, child) => child!, // giữ lại child nếu có
          );
        },
      ),
    );
  }
}
