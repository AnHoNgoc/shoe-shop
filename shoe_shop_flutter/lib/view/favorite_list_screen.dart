import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/product_list.dart';
import '../data/viewModel/auth_view_model.dart';
import '../data/viewModel/favorite_view_model.dart';
import 'login_require_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Selector<AuthViewModel, bool>(
      selector: (_, auth) => auth.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        if (!isLoggedIn) {
          return const RequireLoginScreen();
        }

        return Consumer<FavoriteViewModel>(
          builder: (context, favoriteVM, _) {
            if (favoriteVM.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final favorites = favoriteVM.favoriteList
                .where((item) => item.isFavorite && item.product != null)
                .toList();

            if (favorites.isEmpty) {
              return Center(
                child: Text(
                  "No favorite products yet.",
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
            }

            return Scaffold(
              body: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    Center(
                      child: Text(
                        "Wishlist",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final product = favorites[index].product!;

                          return ProductCard(
                            id: product.id,
                            name: product.name,
                            image: product.image,
                            price: product.price,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
