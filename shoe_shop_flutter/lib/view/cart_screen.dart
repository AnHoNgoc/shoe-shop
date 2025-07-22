import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_shop_flutter/data/viewModel/auth_view_model.dart';
import 'package:shoe_shop_flutter/routes/app_routes.dart';
import '../constants/app_colors.dart';
import '../data/viewModel/cart_view_model.dart';
import '../utils/dialog_remove_cart.dart';
import 'login_require_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _didFetch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didFetch) {
      _didFetch = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        if (authViewModel.isLoggedIn) {
          final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
          cartViewModel.fetchCart();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AuthViewModel, bool>(
      selector: (context, authProvider) => authProvider.isLoggedIn,
      builder: (context, isLoggedIn, child) {
        if (!isLoggedIn) {
          return const RequireLoginScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Cart",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Consumer<CartViewModel>(
            builder: (context, cartVM, child) {
              if (cartVM.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final items = cartVM.cartList;
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'Cart is empty',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      key: const PageStorageKey('cartList'),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 15.h,
                            horizontal: 8.w,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: CachedNetworkImage(
                                  imageUrl: item.image,
                                  width: 80.w,
                                  height: 80.w,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: const CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.image_not_supported, size: 20.sp),
                                ),
                              ),
                              SizedBox(width: 12.w),

                              // 2. Product Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      '${item.categoryName}',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    Text(
                                      '\$${item.price.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                              ),

                              // 3. Quantity + Total
                              Column(
                                children: [
                                  Text(
                                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, size: 16.sp),
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          cartVM.decrementCartItem(item.productId);
                                        },
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, size: 16.sp),
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          cartVM.incrementCartItem(item.productId);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              // 4. Delete icon
                              IconButton(
                                icon: Icon(Icons.close, size: 20.sp),
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  final confirm = await DialogRemoveCart.showLogoutConfirmationDialog(context);
                                  if (confirm) {
                                    await cartVM.deleteCartItem(item.productId);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Total Amount (dùng Selector để tránh rebuild toàn bộ)
                  Selector<CartViewModel, double>(
                    selector: (_, vm) => vm.totalAmount,
                    builder: (_, total, __) {
                      return Padding(
                        padding: EdgeInsets.all(10.0.w),
                        child: Text(
                          'Total amount: \$${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: SizedBox(
                      width: 200, // Chiều rộng cố định, bạn có thể chỉnh tùy ý
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.checkout);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          "Checkout",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: AppColors.white, // 👈 Thêm dòng này
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
