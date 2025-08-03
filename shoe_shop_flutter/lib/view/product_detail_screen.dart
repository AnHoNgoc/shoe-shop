import 'package:flutter/material.dart';
import 'package:shoe_shop_flutter/data/viewModel/cart_view_model.dart';
import '../components/app_snack_bar.dart';
import '../components/app_toast.dart';
import '../components/review_item.dart';
import '../constants/app_colors.dart';
import '../data/model/product_detail_model.dart';
import '../data/viewModel/auth_view_model.dart';
import '../data/viewModel/favorite_view_model.dart';
import '../data/viewModel/product_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../data/viewModel/review_view_model.dart';
import '../utils/dialog_add_cart.dart';
import '../utils/dialog_auth.dart';
import '../utils/dialog_review.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late AuthViewModel _authViewModel;
  late ReviewViewModel _reviewViewModel;
  ProductDetail? product;
  bool isLoading = true;
  late ProductViewModel _productViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = context.read<AuthViewModel>();
      _reviewViewModel = context.read<ReviewViewModel>();
      _productViewModel = context.read<ProductViewModel>();
      loadProductDetail();
    });
  }

  void handleReview(BuildContext context) {
    if (!_authViewModel.isLoggedIn) {
      DialogAuth.showLoginRequiredDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ReviewDialog(
          onSubmit: (rating, comment) async {
            try {
              await _reviewViewModel.createReview(widget.productId, rating, comment);
              if (!mounted) return;
              AppToast.showSuccess("Review submitted successfully!");
              await loadProductDetail();
            } catch (e) {
              if (!mounted) return;
              AppToast.showError(e.toString()); // hoặc xử lý dạng Exception riêng
            }
          }
      ),
    );
  }

  Future<void> loadProductDetail() async {
    final result = await _productViewModel.loadProductDetail(widget.productId);
    if (mounted) {
      setState(() {
        product = result;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double scaleFactor = 1.5;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Detail',
          style: TextStyle(fontSize: 16.sp * scaleFactor),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : product == null
          ? const Center(child: Text('Product not found'))
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w * scaleFactor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: CachedNetworkImage(
                      imageUrl: product!.image,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8.h * scaleFactor,
                    left: 8.w * scaleFactor,
                    child: Consumer<FavoriteViewModel>(
                      builder: (context, favoriteVM, _) {
                        final isFavorite = favoriteVM.isFavorite(widget.productId);
                        return GestureDetector(
                          onTap: () {
                            if (!_authViewModel.isLoggedIn) {
                              DialogAuth.showLoginRequiredDialog(context);
                              return;
                            }
                            favoriteVM.toggleFavorite(widget.productId);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6.w * scaleFactor),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.grey400,
                                width: 1.5.w * scaleFactor,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? AppColors.red : AppColors.grey,
                              size: 20.w * scaleFactor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h * scaleFactor),
              Text(
                product!.name,
                style: TextStyle(
                  fontSize: 18.sp * scaleFactor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Category: ${product!.category?.name ?? ""}",
                style: TextStyle(fontSize: 14.sp * scaleFactor),
              ),
              SizedBox(height: 8.h * scaleFactor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product!.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: AppColors.redAccent,
                      fontSize: 16.sp * scaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Consumer<CartViewModel>(
                    builder: (context, cartVM, _) {
                      final quantity = cartVM.getQuantityInCart(product!.id);
                      return GestureDetector(
                        onTap: () async {
                          if (!_authViewModel.isLoggedIn) {
                            DialogAuth.showLoginRequiredDialog(context);
                            return;
                          }

                          final confirm = await DialogAddCart.showLogoutConfirmationDialog(context);
                          if (!confirm) return;

                          try {
                            await cartVM.addCartItem(product!.id);
                            if (!context.mounted) return;
                            AppSnackBar.showSuccess(context, 'Product added to cart!');
                          } catch (e) {
                            if (!context.mounted) return;
                            AppSnackBar.showError(context, e.toString());
                          }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: AppColors.black87,
                              size: 22.w * scaleFactor,
                            ),
                            if (quantity > 0)
                              Positioned(
                                right: -6.w,
                                top: -6.h,
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: const BoxDecoration(
                                    color: AppColors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$quantity',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 12.h * scaleFactor),
              Text(
                "Quantity: ${product!.quantity}",
                style: TextStyle(fontSize: 14.sp * scaleFactor),
              ),
              SizedBox(height: 6.h * scaleFactor),
              SizedBox(height: 16.h * scaleFactor),
              Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 14.sp * scaleFactor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h * scaleFactor),
              Builder(
                builder: (context) {
                  final reviews = product!.reviews ?? [];

                  if (reviews.isEmpty) {
                    return Text(
                      "No reviews yet.",
                      style: TextStyle(
                        fontSize: 14.sp * scaleFactor,
                        color: AppColors.grey,
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: reviews.map((review) {
                      return ReviewItem(
                        review: review,
                        scaleFactor: scaleFactor,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleReview(context),
        backgroundColor: AppColors.teal,
        child: const Icon(Icons.rate_review),
      ),
    );
  }
}
