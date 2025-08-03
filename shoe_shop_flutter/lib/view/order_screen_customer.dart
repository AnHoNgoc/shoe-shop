import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/timeline.dart';
import '../data/viewModel/order_view_model.dart';
import '../utils/dialog_confirm.dart';

class OrderScreenCustomer extends StatelessWidget {
  const OrderScreenCustomer({super.key});

  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViewModel>(
      builder: (context, orderVM, child) {
        if (orderVM.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final orders = orderVM.orderListByUser;

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
                  image: const DecorationImage(
                    image: AssetImage('asset/images/wood_bg.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
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
                                  builder: (_) => const DialogConfirm(),
                                );
                                if (confirmed == true)  {
                                  await orderVM.updateStatus(order.id, "cancelled");
                                  await orderVM.fetchOrdersByUser();
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
                      HorizontalTimeline(orderId: order.id, status: order.status),
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
  }
}