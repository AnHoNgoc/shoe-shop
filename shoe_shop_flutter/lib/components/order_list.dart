import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shoe_shop_flutter/components/timeline.dart';
import '../data/model/order_model.dart';

class OrderList extends StatelessWidget {
  final OrderModel order;
  const OrderList({super.key, required this.order});

  String formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
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
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("👟 Products", style: TextStyle(fontSize: 14.sp)),
                Text(
                  "👤 ${order.user?.username ?? 'Unknown'}",
                  style: TextStyle(fontSize: 13.sp, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            /// Product List
            SizedBox(height: 4.h),
            ...order.products.map((product) => Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
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
                  Text("\$${product.price.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 13.sp)),
                  Text(" x ${product.quantity}",
                      style: TextStyle(fontSize: 13.sp)),
                ],
              ),
            )),

            SizedBox(height: 6.h),
            Text("📍 Address: ${order.address}", style: TextStyle(fontSize: 13.sp)),
            Text("📞 Phone: ${order.phoneNumber}", style: TextStyle(fontSize: 13.sp)),
            Text("💵 Total: \$${order.totalAmount}", style: TextStyle(fontSize: 13.sp)),
            Text("🕒 Created: ${formatDate(order.createdAt)}", style: TextStyle(fontSize: 13.sp)),
            const Divider(),
            Text("📦 Order Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            SizedBox(height: 8.h),
            HorizontalTimeline(orderId: order.id, status: order.status),
          ],
        ),
      ),
    );
  }
}