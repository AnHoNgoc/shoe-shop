import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shoe_shop_flutter/utils/dialog_order.dart';
import '../components/app_toast.dart';
import '../constants/app_colors.dart';
import '../data/viewModel/cart_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/viewModel/order_view_model.dart';
import '../routes/app_routes.dart';
import '../utils/validator.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartVM = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment', style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: cartVM.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200.h,
              width: 400.w,
              child: Lottie.asset('asset/lottie/payment.json'),
            ),
            SizedBox(height: 24.h),

            // Address Field
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Shipping Address',
                labelStyle: TextStyle(fontSize: 14.sp),
              ),
            ),
            // Phone Field
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 24.h),

            Text(
              "Selected Items:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
            SizedBox(height: 8.h),

            // Cart Items
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                itemCount: cartVM.cartList.length,
                itemBuilder: (context, index) {
                  final item = cartVM.cartList[index];
                  return ListTile(
                    title: Text("${item.name} x${item.quantity}", style: TextStyle(fontSize: 14.sp)),
                    trailing: Text(
                      " \$${(item.price * item.quantity).toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Center(
              child: Text(
                "Total:  \$${cartVM.totalAmount.toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 24.h),
            // Buttons
            Consumer<OrderViewModel>(
              builder: (context, orderVM, _) {
                return Row(
                  children: [
                    // Pay on Delivery Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: orderVM.isLoading
                            ? null
                            : () async {
                          final error = AppValidator.validateAddressAndPhone(
                            _addressController.text,
                            _phoneController.text,
                          );

                          if (error != null) {
                            AppToast.showError(error);
                            return;
                          }

                          final confirm = await DialogOrder.showLogoutConfirmationDialog(context);
                          if (!confirm) return;

                          try {
                            await orderVM.checkout(
                              _addressController.text,
                              _phoneController.text,
                            );

                            AppToast.showSuccess('✅ Order placed successfully!');
                            cartVM.clearCart();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.main,
                                  (route) => false,
                            );
                          } catch (e) {
                            AppToast.showError(e.toString());
                          }
                        },
                        icon: Icon(Icons.local_shipping, color: AppColors.deepOrange, size: 20.sp),
                        label: orderVM.isLoading
                            ? SizedBox(
                          width: 16.sp,
                          height: 16.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.deepOrange,
                          ),
                        )
                            : Text(
                          "Pay on Delivery",
                          style: TextStyle(
                            color: AppColors.deepOrange,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.deepOrange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Stripe Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: orderVM.isLoading
                            ? null
                            : () async {
                          final error = AppValidator.validateAddressAndPhone(
                            _addressController.text,
                            _phoneController.text,
                          );

                          if (error != null) {
                            AppToast.showError(error);
                            return;
                          }

                          final confirm = await DialogOrder.showLogoutConfirmationDialog(context);
                          if (!confirm) return;

                          try {
                            await orderVM.stripeCheckout(
                              _addressController.text,
                              _phoneController.text,
                            );
                          } catch (e) {
                            AppToast.showError(e.toString());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: orderVM.isLoading
                            ? SizedBox(
                          width: 16.sp,
                          height: 16.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          "Pay with Stripe",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}