import 'package:flutter/material.dart';

class HorizontalTimeline extends StatelessWidget {
  final String status;
  final List<String> steps;

  const HorizontalTimeline({
    super.key,
    required this.status,
    this.steps = const ['pending', 'confirmed', 'shipping', 'completed'],
  });

  @override
  Widget build(BuildContext context) {
    final currentStep = steps.indexOf(status);
    const double dotSize = 28;
    const double lineLength = 60;

    if (status == 'cancelled') {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          '❌ Order Cancelled',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (currentStep == -1) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          '⚠️ Unknown order status',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // 🔹 Nút và đường kẻ nằm ngang
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                final isDone = stepIndex <= currentStep;

                return Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: isDone ? Colors.green : Colors.white,
                    border: Border.all(
                      color: isDone ? Colors.green : Colors.grey,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: isDone
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : const SizedBox.shrink(),
                );
              } else {
                final leftStep = (index - 1) ~/ 2;
                final isDone = leftStep < currentStep;

                return Container(
                  width: lineLength,
                  height: 2,
                  color: isDone ? Colors.green : Colors.grey.withOpacity(0.3),
                );
              }
            }),
          ),
          const SizedBox(height: 8),
          // 🔹 Text nằm bên dưới, canh giữa theo dot
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
                      fontSize: 12,
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