class Cart {
  final String id;
  final List<CartDetailItem> items;
  final int totalItems;
  final double totalPrice;

  Cart({
    required this.id,
    required this.items,
    required this.totalItems,
    required this.totalPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((item) => CartDetailItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalItems: json['totalItems'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalItems': totalItems,
      'totalPrice': totalPrice,
    };
  }

  // Create an empty cart
  factory Cart.empty() {
    return Cart(
      id: '',
      items: [],
      totalItems: 0,
      totalPrice: 0,
    );
  }

  // Create a copy with updated fields
  Cart copyWith({
    String? id,
    List<CartDetailItem>? items,
    int? totalItems,
    double? totalPrice,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      totalItems: totalItems ?? this.totalItems,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class CartDetailItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  CartDetailItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory CartDetailItem.fromJson(Map<String, dynamic> json) {
    return CartDetailItem(
      productId: json['productId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  // Create a copy with updated fields
  CartDetailItem copyWith({
    String? productId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartDetailItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}