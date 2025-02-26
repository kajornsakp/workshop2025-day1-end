import 'package:chopee/model/order_item.dart';
import 'package:chopee/model/shipping_address.dart';

class Order {
  final String? id;
  final String? userId;
  final List<OrderItem>? items;
  final double? totalAmount;
  final String status;
  final DateTime? createdAt;
  final ShippingAddress shippingAddress;
  final String paymentMethod;
  final String? trackingNumber;

  Order({
    this.id,
    this.userId,
    this.items,
    this.totalAmount,
    required this.status,
    this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
    this.trackingNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem>? orderItems;
    if (json['items'] != null) {
      orderItems = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList();
    }

    return Order(
      id: json['id'],
      userId: json['userId'],
      items: orderItems,
      totalAmount: json['totalAmount'] != null ? (json['totalAmount'] as num).toDouble() : null,
      status: json['status'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
      paymentMethod: json['paymentMethod'],
      trackingNumber: json['trackingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod,
      'status': status,
    };

    if (trackingNumber != null) data['trackingNumber'] = trackingNumber;

    return data;
  }
}
