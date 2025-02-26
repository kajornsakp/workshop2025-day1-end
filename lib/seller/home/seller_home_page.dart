import 'package:chopee/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SellerHomePage extends StatefulWidget {
  final Widget child;
  
  const SellerHomePage({
    super.key,
    required this.child,
  });

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  int _calculateSelectedIndex(BuildContext context) {
    final GoRouterState routerState = GoRouterState.of(context);
    final String location = routerState.uri.toString();
    
    if (location.startsWith('/seller/dashboard')) {
      return 0;
    }
    if (location.startsWith('/seller/products')) {
      return 1;
    }
    if (location.startsWith('/seller/orders')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.navigateToSellerDashboard();
        break;
      case 1:
        context.navigateToSellerProducts();
        break;
      case 2:
        context.navigateToSellerOrders();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.navigateToHome();
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
