import 'package:chopee/model/cart.dart';
import 'package:chopee/model/cart_item.dart';
import 'package:chopee/model/category.dart';
import 'package:chopee/model/order.dart';
import 'package:chopee/model/payment.dart';
import 'package:chopee/model/product.dart';
import 'package:chopee/model/review.dart';
import 'package:chopee/model/shipping_address.dart';
import 'package:chopee/model/user.dart';
import 'package:dio/dio.dart';

// API Services
class ProductApi {
  final NetworkService _networkService;

  ProductApi(this._networkService);

  Future<List<Product>> getAllProducts({String? category, String? search}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;

    final response = await _networkService.get('/products', queryParams: queryParams);
    final List<dynamic> productsJson = response['products'];
    return productsJson.map((json) {
      return Product.fromJson(json);
    }).toList();
  }

  Future<Product> getProductById(String productId) async {
    final response = await _networkService.get('/products/$productId');
    return Product.fromJson(response);
  }

  Future<Product> createProduct(Product product) async {
    final response = await _networkService.post('/products', data: product.toJson());
    return Product.fromJson(response);
  }

  Future<void> updateProduct(String productId, Product product) async {
    await _networkService.put('/products/$productId', data: product.toJson());
  }

  Future<void> deleteProduct(String productId) async {
    await _networkService.delete('/products/$productId');
  }

  Future<List<Product>> getSellerProducts() async {
    final response = await _networkService.get('/products/seller');
    final List<dynamic> productsJson = response['products'];
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }
}

class CategoryApi {
  final NetworkService _networkService;

  CategoryApi(this._networkService);

  Future<List<Category>> getAllCategories() async {
    final response = await _networkService.get('/categories');
    final List<dynamic> categoriesJson = response['categories'];
    return categoriesJson.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final response = await _networkService.get('/categories/$categoryId/products');
    final List<dynamic> productsJson = response['products'];
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }
}

class CartApi {
  final NetworkService _networkService;

  CartApi(this._networkService);

  Future<Cart> getCart() async {
    final response = await _networkService.get('/cart');
    return Cart.fromJson(response);
  }

  Future<Cart> addToCart(CartItem cartItem) async {
    final response = await _networkService.post('/cart', data: cartItem.toJson());
    return Cart.fromJson(response["cart"]);
  }

  Future<void> updateCartItem(String cartItemId, int quantity) async {
    await _networkService.put('/cart/$cartItemId', data: {'quantity': quantity});
  }

  Future<void> removeFromCart(String cartItemId) async {
    await _networkService.delete('/cart/$cartItemId');
  }
}

class OrderApi {
  final NetworkService _networkService;

  OrderApi(this._networkService);

  Future<Order> createOrder(ShippingAddress shippingAddress, String paymentMethod) async {
    final data = {
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod,
    };
    final response = await _networkService.post('/orders', data: data);
    return Order.fromJson(response);
  }

  Future<List<Order>> getOrderHistory() async {
    final response = await _networkService.get('/orders');
    final List<dynamic> ordersJson = response['orders'];
    return ordersJson.map((json) => Order.fromJson(json)).toList();
  }

  Future<Order> getOrderById(String orderId) async {
    final response = await _networkService.get('/orders/$orderId');
    return Order.fromJson(response);
  }

  Future<void> updateOrder(String orderId, {String? status, String? trackingNumber, ShippingAddress? shippingAddress}) async {
    final data = <String, dynamic>{};
    if (status != null) data['status'] = status;
    if (trackingNumber != null) data['trackingNumber'] = trackingNumber;
    if (shippingAddress != null) data['shippingAddress'] = shippingAddress.toJson();

    await _networkService.put('/orders/$orderId', data: data);
  }
}

class ReviewApi {
  final NetworkService _networkService;

  ReviewApi(this._networkService);

  Future<void> submitReview(Review review) async {
    await _networkService.post('/reviews', data: review.toJson());
  }

  Future<List<Review>> getProductReviews(String productId) async {
    final response = await _networkService.get('/products/$productId/reviews');
    final List<dynamic> reviewsJson = response['reviews'];
    return reviewsJson.map((json) => Review.fromJson(json)).toList();
  }

  Future<void> updateReview(String reviewId, {double? rating, String? comment}) async {
    final data = <String, dynamic>{};
    if (rating != null) data['rating'] = rating;
    if (comment != null) data['comment'] = comment;

    await _networkService.put('/reviews/$reviewId', data: data);
  }

  Future<void> deleteReview(String reviewId) async {
    await _networkService.delete('/reviews/$reviewId');
  }
}

class UserApi {
  final NetworkService _networkService;

  UserApi(this._networkService);

  Future<User> getUserProfile() async {
    final response = await _networkService.get('/users/profile');
    return User.fromJson(response);
  }

  Future<void> updateUserProfile({String? displayName, String? photoURL, String? email}) async {
    final data = <String, dynamic>{};
    if (displayName != null) data['displayName'] = displayName;
    if (photoURL != null) data['photoURL'] = photoURL;
    if (email != null) data['email'] = email;

    await _networkService.put('/users/profile', data: data);
  }

  Future<List<User>> getAllUsers() async {
    final response = await _networkService.get('/users');
    final List<dynamic> usersJson = response['users'];
    return usersJson.map((json) => User.fromJson(json)).toList();
  }

  Future<void> createUser(User user) async {
    await _networkService.post('/users', data: user.toJson());
  }

  Future<void> updateUser(String userId, User user) async {
    await _networkService.put('/users/$userId', data: user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await _networkService.delete('/users/$userId');
  }
}

class PaymentApi {
  final NetworkService _networkService;

  PaymentApi(this._networkService);

  Future<dynamic> initiateCheckout(Payment payment) async {
    return await _networkService.post('/payments/checkout', data: payment.toJson());
  }

  Future<String> getPaymentStatus() async {
    final response = await _networkService.get('/payments/status');
    return response['paymentStatus'];
  }
}

class NetworkService {
  // Singleton instance
  static NetworkService? _instance;
  
  final Dio _dio = Dio();
  final String _baseUrl;
  String? _authToken;

  // API Services
  late ProductApi productApi;
  late CategoryApi categoryApi;
  late CartApi cartApi;
  late OrderApi orderApi;
  late ReviewApi reviewApi;
  late UserApi userApi;
  late PaymentApi paymentApi;

  // Factory constructor to return the singleton instance
  factory NetworkService({required String baseUrl, String? authToken}) {
    // If instance doesn't exist or if baseUrl is different, create a new instance
    if (_instance == null || _instance!._baseUrl != baseUrl) {
      _instance = NetworkService._internal(baseUrl: baseUrl, authToken: authToken);
    } else if (authToken != null && _instance!._authToken != authToken) {
      // Update auth token if it's different
      _instance!.setAuthToken(authToken);
    }
    return _instance!;
  }

  // Private constructor for internal use
  NetworkService._internal({
    required String baseUrl,
    String? authToken,
  }) : _baseUrl = baseUrl {
    _authToken = authToken;
    _initDio();
    _initApiServices();
  }

  // Static method to get the instance without parameters
  static NetworkService get instance {
    if (_instance == null) {
      throw Exception('NetworkService not initialized. Call NetworkService() with baseUrl first.');
    }
    return _instance!;
  }

  void _initDio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_authToken';
    }

    // Add interceptors for logging, error handling, etc.
    // _dio.interceptors.add(LogInterceptor(
    //   requestBody: true,
    //   responseBody: true,
    // ));

    // Add error handling interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) {
        return handler.next(e);
      },
    ));
  }

  void _initApiServices() {
    productApi = ProductApi(this);
    categoryApi = CategoryApi(this);
    cartApi = CartApi(this);
    orderApi = OrderApi(this);
    reviewApi = ReviewApi(this);
    userApi = UserApi(this);
    paymentApi = PaymentApi(this);
  }

  void setAuthToken(String token) {
    _authToken = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _authToken = null;
    _dio.options.headers.remove('Authorization');
  }

  // Generic GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<dynamic> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(e.message ?? 'Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        String message;
        try {
          message = e.response?.data['error'] ?? 'Bad response';
        } catch (_) {
          message = 'Bad response';
        }
        
        if (statusCode == 401) {
          return UnauthorizedException(message);
        } else if (statusCode == 403) {
          return ForbiddenException(message);
        } else if (statusCode == 404) {
          return NotFoundException(message);
        } else {
          return ApiException(
            statusCode: statusCode,
            message: message,
          );
        }
      case DioExceptionType.cancel:
        return RequestCancelledException(e.message ?? 'Request cancelled');
      default:
        return NetworkException(e.message ?? 'Network error occurred');
    }
  }
}

// Custom exceptions
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException({required this.statusCode, required this.message});
  @override
  String toString() => 'ApiException: $statusCode - $message';
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  @override
  String toString() => 'Unauthorized: $message';
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);
  @override
  String toString() => 'Forbidden: $message';
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
  @override
  String toString() => 'Not Found: $message';
}

class RequestCancelledException implements Exception {
  final String message;
  RequestCancelledException(this.message);
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}
