import 'package:flutter/cupertino.dart';
import 'package:shoe_shop_flutter/view/cart_screen.dart';
import 'package:shoe_shop_flutter/view/change_password_screen.dart';
import 'package:shoe_shop_flutter/view/checkout_screen.dart';
import 'package:shoe_shop_flutter/view/favorite_list_screen.dart';
import 'package:shoe_shop_flutter/view/home_screen.dart';
import 'package:shoe_shop_flutter/view/login_require_screen.dart';
import 'package:shoe_shop_flutter/view/login_screen.dart';
import 'package:shoe_shop_flutter/view/main_screen.dart';
import 'package:shoe_shop_flutter/view/order_screen.dart';
import 'package:shoe_shop_flutter/view/profile_screen.dart';
import 'package:shoe_shop_flutter/view/sign_up_screen.dart';

class AppRoutes {
  static const String main = '/';
  static const String home = '/home';
  static const String about = '/about';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String loginRequire = '/login-require';
  static const String favorite = '/favorite';
  static const String cart = '/cart';
  static const String order = '/order';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';
  static const String checkout = '/checkout';


  static Map<String, WidgetBuilder> get routes => {
    main: (context) => MainScreen(),
    home: (context) => HomeScreen(),
    login: (context) => LoginScreen(),
    loginRequire: (context) => RequireLoginScreen(),
    favorite: (context) => FavoriteListScreen(),
    cart: (context) => CartScreen(),
    order: (context) => OrderScreen(),
    profile: (context) => ProfileScreen(),
    signUp: (context) => SignUpScreen(),
    changePassword: (context) => ChangePasswordScreen(),
    checkout: (context) => CheckoutScreen(),
  };
}