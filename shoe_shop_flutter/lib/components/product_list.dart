import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_shop_flutter/components/pagination.dart';
import 'package:shoe_shop_flutter/data/viewModel/favorite_view_model.dart';
import 'package:shoe_shop_flutter/utils/dialog_auth.dart';
import '../data/model/product_model.dart';
import '../data/viewModel/auth_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/viewModel/cart_view_model.dart';
import '../utils/dialog_add_cart.dart';
import '../view/product_detail_screen.dart';
import 'app_snack_bar.dart';

class ProductList extends StatefulWidget {
  final Stream<List<Product>> productStream;
  final Stream<int> totalPagesStream;
  final int currentPage;
  final Function(int) onPageChanged;

  const ProductList({
    super.key,
    required this.productStream,
    required this.totalPagesStream,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late FavoriteViewModel _favoriteViewModel;
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _authViewModel = context.read<AuthViewModel>();
        _favoriteViewModel = context.read<FavoriteViewModel>();

        if (_authViewModel.isLoggedIn && _authViewModel.userId != null) {
          _favoriteViewModel.fetchFavorites();
        }
      } catch (e, stack) {
        print("❌ Lỗi xảy ra trong addPostFrameCallback: $e");
        print("Stacktrace: $stack");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = screenWidth > 900.w
            ? 4
            : screenWidth > 600.w
            ? 3
            : 2;
        final spacing = 16.w;

        return StreamBuilder<int>(
          stream: widget.totalPagesStream,
          builder: (context, totalPageSnapshot) {
            final totalPages = totalPageSnapshot.data ?? 1;

            return StreamBuilder<List<Product>>(
              stream: widget.productStream,
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productSnapshot.hasError) {
                  return Center(child: Text("Error: ${productSnapshot.error}"));
                } else if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                  return const Center(child: Text("No products available"));
                } else {
                  List<Product> products = productSnapshot.data!;
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              id: product.id,
                              name: product.name,
                              image: product.image,
                              price: product.price,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (totalPages > 1)
                        Pagination(
                          currentPage: widget.currentPage,
                          totalPages: totalPages,
                          onPageChanged: widget.onPageChanged,
                        ),
                    ],
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}


// --- ProductCard ---

class ProductCard extends StatefulWidget {
  final String name;
  final String image;
  final double price;
  final int id;

  const ProductCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.id,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late FavoriteViewModel _favoriteViewModel;
  late CartViewModel _cartViewModel;
  late AuthViewModel _authViewModel;


  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _favoriteViewModel = context.read<FavoriteViewModel>();
    _cartViewModel = context.read<CartViewModel>();
    _authViewModel = context.read<AuthViewModel>();

    if (!_isFetched && _authViewModel.isLoggedIn) {
      _isFetched = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _cartViewModel.fetchCart();
      });
    }
  }

  void handleFavoriteTap(BuildContext context) {
    if (!_authViewModel.isLoggedIn) {
      DialogAuth.showLoginRequiredDialog(context);
      return;
    }
    _favoriteViewModel.toggleFavorite(widget.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Toggled favorite!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void handleAddToCartTap(BuildContext context) async {
    if (!_authViewModel.isLoggedIn) {
      DialogAuth.showLoginRequiredDialog(context);
      return;
    }

    final confirm = await DialogAddCart.showLogoutConfirmationDialog(context);


    if (confirm) {

      try {
        await _cartViewModel.addCartItem(widget.id);
        if (!context.mounted) return;
        AppSnackBar.showSuccess(context, 'Product added to cart!');
      } catch (e) {
        if (!context.mounted) return;
        AppSnackBar.showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: widget.id),
          ),
        );
      },
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image + Favorite icon
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.redAccent),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Consumer<FavoriteViewModel>(
                    builder: (context, favoriteViewModel, _) {
                      final isFavorite = favoriteViewModel.isFavorite(widget.id);
                      return GestureDetector(
                        onTap: () => handleFavoriteTap(context),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.5.w,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 20.w,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Product info + Cart icon
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${widget.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Consumer<CartViewModel>(
                        builder: (context, cartViewModel, _) {
                          final quantityInCart = cartViewModel.getQuantityInCart(widget.id);
                          return GestureDetector(
                            onTap: () => handleAddToCartTap(context),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.black87,
                                  size: 22.w,
                                ),
                                if (quantityInCart > 0)
                                  Positioned(
                                    right: -6.w,
                                    top: -6.h,
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$quantityInCart',
                                        style: TextStyle(
                                          color: Colors.white,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}














