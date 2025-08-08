import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../data/viewModel/auth_view_model.dart';
import '../data/viewModel/order_view_model.dart';
import '../utils/dialog_confirm.dart';

class HorizontalTimeline extends StatelessWidget {
  final int orderId;
  final String status;
  final List<String> steps;

  const HorizontalTimeline({
    super.key,
    required this.orderId,
    required this.status,
    this.steps = const ['pending', 'confirmed', 'shipping', 'completed'],
  });

  @override
  Widget build(BuildContext context) {
    final currentStep = steps.indexOf(status);
    final double dotSize = 28.w;
    final double lineLength = 60.w;

    if (status == 'cancelled') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(
          '❌ Order Cancelled',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    if (currentStep == -1) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(
          '⚠️ Unknown order status',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                final isDone = stepIndex <= currentStep;

                return GestureDetector(
                  onTap: () async {
                    final userAccount = context.read<AuthViewModel>().userAccount;
                    final groupName = userAccount?.group;

                    if (groupName == 'customer') return;

                    // Nếu bấm vào step cũ thì cũng không cho update
                    if (stepIndex <= currentStep) return;

                    final orderVM = context.read<OrderViewModel>();

                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => const DialogConfirm(
                        title: 'Update Status',
                        content: 'Do you want to update the status of this order?',
                      ),
                    );

                    if (confirmed == true) {
                      final newStatus = steps[stepIndex];
                      try {
                        await orderVM.updateStatus(orderId, newStatus);
                        await orderVM.fetchOrders(page: 1);
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: isDone ? Colors.green : Colors.white,
                      border: Border.all(
                        color: isDone ? Colors.green : Colors.grey,
                        width: 2.w,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: isDone
                        ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                        : const SizedBox.shrink(),
                  ),
                );
              } else {
                final leftStep = (index - 1) ~/ 2;
                final isDone = leftStep < currentStep;

                return Container(
                  width: lineLength,
                  height: 2.h,
                  color: isDone ? Colors.green : Colors.grey.withOpacity(0.3),
                );
              }
            }),
          ),
          SizedBox(height: 8.h),
          Row(
            children: List.generate(steps.length, (index) {
              final label = steps[index];
              final isDone = index <= currentStep;
              return SizedBox(
                width: dotSize + lineLength,
                child: Center(
                  child: Text(
                    label[0].toUpperCase() + label.substring(1),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isDone ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}