import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shoe_shop_flutter/components/order_list.dart';

import '../components/order_filter.dart';
import '../components/pagination.dart';
import '../data/viewModel/order_view_model.dart';


class OrderScreenAdmin extends StatefulWidget {
  const OrderScreenAdmin({super.key});

  @override
  State<OrderScreenAdmin> createState() => _OrderScreenAdminState();
}

class _OrderScreenAdminState extends State<OrderScreenAdmin> {
  int _currentPage = 1;
  String? _selectedStatus;
  String _sort = 'desc';

  late OrderViewModel _orderViewModel;

  @override
  void initState() {
    super.initState();
    _orderViewModel = context.read<OrderViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    _orderViewModel.fetchOrders(
      page: _currentPage,
      status: _selectedStatus,
      sort: _sort,
    );
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
    _fetchData();
  }

  void _onFilterChanged(String? status, String sort) {
    setState(() {
      _selectedStatus = status;
      _sort = sort;
      _currentPage = 1; // reset page
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          OrderFilterBar(
            selectedStatus: _selectedStatus,
            selectedSort: _sort,
            onFilterChanged: _onFilterChanged,
          ),
          Expanded(
            child: Consumer<OrderViewModel>(
              builder: (context, orderVM, _) {
                if (orderVM.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = orderVM.orderPageModel?.orders ?? [];
                final totalPages = orderVM.orderPageModel?.totalPages ?? 1;

                if (orders.isEmpty) {
                  return const Center(child: Text("Not found"));
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return OrderList(order: order);
                        },
                      ),
                    ),

                    if (totalPages > 1)
                      Pagination(
                        currentPage: _currentPage,
                        totalPages: totalPages,
                        onPageChanged:_onPageChanged,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}