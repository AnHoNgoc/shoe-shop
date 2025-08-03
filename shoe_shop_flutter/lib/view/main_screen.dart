import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_shop_flutter/view/cart_screen.dart';
import 'package:shoe_shop_flutter/view/favorite_list_screen.dart';
import 'package:shoe_shop_flutter/view/home_screen.dart';
import 'package:shoe_shop_flutter/view/order_screen.dart';
import 'package:shoe_shop_flutter/view/profile_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../data/viewModel/auth_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = [
    const HomeScreen(),
    const FavoriteListScreen(),
    const CartScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  int selectedIndex = 0;

  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = context.read<AuthViewModel>();
      _authViewModel.getAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        elevation: 5,
        iconSize: 32,
        selectedItemColor: AppColors.pinkAccent,
        unselectedItemColor: AppColors.black45,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "asset/images/home_dashboard.png",
              height: 30.h,
              color: selectedIndex == 0 ? AppColors.pinkAccent : AppColors.black45,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "asset/images/favorite_dashboard.png",
              height: 30.h,
              color: selectedIndex == 1 ? AppColors.pinkAccent : AppColors.black45,
            ),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, -12), // Nhô lên một chút
              child: Container(

                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.pinkAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.asset(
                  "asset/images/cart_dashboard.png",
                  height: 32.h,
                  color: Colors.white,
                ),
              ),
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "asset/images/order_dashboard.png",
              height: 30.h,
              color: selectedIndex == 3 ? AppColors.pinkAccent : AppColors.black45,
            ),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "asset/images/profile_dashboard.png",
              height: 30.h,
              color: selectedIndex == 4 ? AppColors.pinkAccent : AppColors.black45,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
