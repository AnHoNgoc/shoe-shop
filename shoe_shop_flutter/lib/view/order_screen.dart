import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/viewModel/auth_view_model.dart';
import '../data/viewModel/order_view_model.dart';
import 'login_require_screen.dart';
import 'order_screen_admin.dart';
import 'order_screen_customer.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderVM = context.read<OrderViewModel>();
      orderVM.fetchOrdersByUser();
      orderVM.fetchOrders(page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AuthViewModel, bool>(
      selector: (context, authVM) => authVM.isLoggedIn,
      builder: (context, isLoggedIn, child) {
        if (!isLoggedIn) return const RequireLoginScreen();

        final userAccount = context.read<AuthViewModel>().userAccount;

        if (userAccount == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final groupName = userAccount.group.name;

        if (groupName == 'customer') {
          return const OrderScreenCustomer();
        } else {
          return const OrderScreenAdmin();
        }
      },
    );
  }
}