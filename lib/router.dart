import 'package:chopee/buyer/cart/cart_page.dart';
import 'package:chopee/buyer/category/category_page.dart';
import 'package:chopee/buyer/home/home_page.dart';
import 'package:chopee/buyer/menu/menu_page.dart';
import 'package:chopee/login/login_page.dart';
import 'package:chopee/buyer/order/order_page.dart';
import 'package:chopee/buyer/product/product_detail_page.dart';
import 'package:chopee/buyer/product/product_list_page.dart';
import 'package:chopee/seller/home/seller_home_page.dart';
import 'package:chopee/seller/dashboard/seller_dashboard_page.dart';
import 'package:chopee/seller/order/seller_order_page.dart';
import 'package:chopee/seller/product/seller_product_edit_page.dart';
import 'package:chopee/seller/product/seller_product_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';


// Add this function to configure URL strategy
void configureApp() {
  // Use path URL strategy for web platforms
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _buyerNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'buyer');
final GlobalKey<NavigatorState> _sellerNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'seller');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    if (FirebaseAuth.instance.currentUser == null) {
      return '/login';
    }
    return null; // Return null to continue with normal navigation
  },
  routes: [
    // Login route
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    
    // Buyer shell route (only for tab-based navigation)
    ShellRoute(
      navigatorKey: _buyerNavigatorKey,
      builder: (context, state, child) {
        return MyHomePage(
          title: 'Chopee',
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ProductListPage(),
          ),
        ),
        GoRoute(
          path: '/menu',
          name: 'menu',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const MenuPage(),
          ),
        ),
      ],
    ),
    
    // Standalone buyer routes (outside the shell)
    GoRoute(
      path: '/cart',
      name: 'cart',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/category/:name',
      name: 'category',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final categoryName = state.pathParameters['name'] ?? 'Category';
        return CategoryPage(categoryName: categoryName);
      },
    ),
    GoRoute(
      path: '/product/:id',
      name: 'product',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailPage(productId: productId);
      },
    ),
    GoRoute(
      path: '/order',
      name: 'order',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OrderPage(),
    ),
    
    // Seller shell route
    ShellRoute(
      navigatorKey: _sellerNavigatorKey,
      builder: (context, state, child) {
        return SellerHomePage(child: child);
      },
      routes: [
        GoRoute(
          path: '/seller/dashboard',
          name: 'sellerDashboard',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SellerDashboardPage(),
          ),
        ),
        GoRoute(
          path: '/seller/products',
          name: 'sellerProducts',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SellerProductsPage(),
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: 'seller_add_product',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const SellerProductEditPage(),
            ),
            GoRoute(
              path: 'edit/:id',
              name: 'seller_edit_product',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final productId = state.pathParameters['id']!;
                return SellerProductEditPage(productId: productId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/seller/orders',
          name: 'sellerOrders',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SellerOrdersPage(),
          ),
        ),
      ],
    ),
    
    // Store settings route (outside the tab navigation)
    GoRoute(
      path: '/seller/settings',
      name: 'seller_store_settings',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text('Store Settings')),
        body: Center(child: Text('Store Settings')),
      ),
    ),
  ],
);

// Extension methods for easier navigation
extension GoRouterExtension on BuildContext {
  // Buyer
  void pushOrder() => push('/order');
  void pushCart() => push('/cart');
  void pushCategory(String name) => push('/category/$name');
  void pushProduct(String id) => push('/product/$id');

  void navigateToHome() => go('/');
  void navigateToMenu() => go('/menu');
  void navigateToLogin() => go('/login');
  // Seller
  void navigateToSellerDashboard() => go('/seller/dashboard');
  void navigateToSellerProducts() => go('/seller/products');
  void navigateToSellerOrders() => go('/seller/orders');
  void navigateToSellerStoreSettings() => push('/seller/settings');
  void navigateToSellerAddProduct() => push('/seller/products/add');
  void pushSellerEditProduct(String id) => push('/seller/products/edit/$id');
}