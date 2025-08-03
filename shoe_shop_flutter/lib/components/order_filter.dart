import 'package:flutter/material.dart';

class OrderFilterBar extends StatelessWidget {
  final String? selectedStatus;
  final String selectedSort;
  final void Function(String? status, String sort) onFilterChanged;

  const OrderFilterBar({
    super.key,
    required this.selectedStatus,
    required this.selectedSort,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          // Status Dropdown
          DropdownButton<String>(
            value: selectedStatus,
            hint: const Text("Status"),
            items: const [
              DropdownMenuItem(value: null, child: Text("All")),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
              DropdownMenuItem(value: 'shipping', child: Text('Shipping')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
              DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
            onChanged: (value) {
              onFilterChanged(value, selectedSort);
            },
          ),
          const SizedBox(width: 16),

          // Sort Dropdown
          DropdownButton<String>(
            value: selectedSort,
            items: const [
              DropdownMenuItem(value: 'desc', child: Text('Newest')),
              DropdownMenuItem(value: 'asc', child: Text('Oldest')),
            ],
            onChanged: (value) {
              if (value != null) {
                onFilterChanged(selectedStatus, value);
              }
            },
          ),
        ],
      ),
    );
  }
}