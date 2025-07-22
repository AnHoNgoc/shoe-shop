import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/timeline.dart';
import '../data/viewModel/auth_view_model.dart';
import '../data/viewModel/order_view_model.dart';
import '../utils/dialog_delete.dart';
import 'login_require_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final orderVM = context.read<OrderViewModel>();
      orderVM.fetchOrders();
    });
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AuthViewModel, bool>(
      selector: (context, authProvider) => authProvider.isLoggedIn,
      builder: (context, isLoggedIn, child) {
        if (!isLoggedIn) return const RequireLoginScreen();

        return Consumer<OrderViewModel>(
          builder: (context, orderVM, child) {
            if (orderVM.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final orders = orderVM.orderList;

            if (orders.isEmpty) {
              return const Scaffold(
                body: Center(child: Text("📭 No orders found.")),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Orders",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('asset/images/wood_bg.png'), // Đường dẫn tới ảnh gỗ
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8), // Lớp phủ làm rõ chữ trên nền gỗ
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " Order Info",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                              ),
                              if (order.status == 'pending')
                                IconButton(
                                  icon: Icon(Icons.delete, size: 20.sp),
                                  tooltip: 'Cancel order',
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => const DialogDelete(),
                                    );
                                    if (confirmed == true) {
                                      // context.read<OrderViewModel>().cancelOrder(order.id);
                                    }
                                  },
                                ),
                            ],
                          ),
                          Text("👟 Products", style: TextStyle(fontSize: 14.sp)),
                          SizedBox(height: 8.h),

                          ...order.products.map((product) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    style: TextStyle(fontSize: 13.sp),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text("\$${product.price.toStringAsFixed(2)} ",
                                    style: TextStyle(fontSize: 13.sp)),
                                Text(" x ${product.quantity}",
                                    style: TextStyle(fontSize: 13.sp)),
                              ],
                            ),
                          )),
                          Text("📍 Address: ${order.address}",
                              style: TextStyle(fontSize: 13.sp)),
                          Text("📞 Phone: ${order.phoneNumber}",
                              style: TextStyle(fontSize: 13.sp)),
                          Text("💵 Total: \$${order.totalAmount}",
                              style: TextStyle(fontSize: 13.sp)),
                          Text("🕒 Created: ${formatDate(order.createdAt)}",
                              style: TextStyle(fontSize: 13.sp)),
                          SizedBox(height: 12.h),
                          const Divider(),
                          Text(
                            "📦 Order Status",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          SizedBox(height: 8.h),
                          HorizontalTimeline(status: order.status),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}