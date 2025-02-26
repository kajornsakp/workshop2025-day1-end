import 'package:app_links/app_links.dart';
import 'package:chopee/blocs/app/app_bloc.dart';
import 'package:chopee/blocs/cart/cart_bloc.dart';
import 'package:chopee/blocs/category_product/category_product_bloc.dart';
import 'package:chopee/blocs/product/product_bloc.dart';
import 'package:chopee/firebase_options.dart';
import 'package:chopee/network/sample_network_service.dart';
import 'package:chopee/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:chopee/blocs/category/category_bloc.dart';
import 'package:chopee/blocs/product_detail/product_detail_bloc.dart';

final appLinks = AppLinks();
final authReadyCompleter = Completer<void>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureApp();
  
  // Set up BLoC observer
  Bloc.observer = AppBlocObserver();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final networkService = NetworkService(baseUrl: 'https://api-lriinp55vq-uc.a.run.app');
  
  // Set up auth state listener
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      router.go('/login');
    } else {
      _updateTokenAndNavigate(user).then((_) async {
        final token = await user.getIdToken();
        if (token != null) {
          networkService.setAuthToken(token);
          if (!authReadyCompleter.isCompleted) {
            authReadyCompleter.complete();
          }
        }
      });
    }
  });
  
  runApp(MyApp(networkService: networkService));
}

// Update this to return a Future
Future<void> _updateTokenAndNavigate(User user) async {
  try {
    final token = await user.getIdToken();
    if (token != null) {
      NetworkService.instance.setAuthToken(token);
      router.go('/');
    }
  } catch (e) {
    print('Error getting token: $e');
    // Handle token retrieval error
  }
}

class MyApp extends StatefulWidget {
  final NetworkService networkService;
  
  const MyApp({super.key, required this.networkService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoRouter _router = router;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        print('uri: ${uri.path}');
        _router.go(uri.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(networkService: widget.networkService),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(networkService: widget.networkService),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(networkService: widget.networkService),
        ),
        BlocProvider<CategoryProductBloc>(
          create: (context) => CategoryProductBloc(networkService: widget.networkService),
        ),
        BlocProvider<ProductDetailBloc>(
          create: (context) => ProductDetailBloc(networkService: widget.networkService),
        ),
      ],
      child: MaterialApp.router(
        title: 'Chopee',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
