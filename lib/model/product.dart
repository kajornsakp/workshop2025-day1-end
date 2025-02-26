class Product {
  final String? id;
  final String name;
  final String? description;
  final String category;
  final double price;
  final int? stock;
  final bool? isActive;
  final String? imageUrl;
  final String? sellerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.category,
    required this.price,
    this.stock,
    this.isActive,
    this.imageUrl,
    this.sellerId,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      isActive: json['isActive'],
      imageUrl: json['imageUrl'],
      sellerId: json['sellerId'],
      createdAt: null,
      updatedAt: null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'category': category,
      'price': price,
    };

    if (id != null) data['id'] = id;
    if (description != null) data['description'] = description;
    if (stock != null) data['stock'] = stock;
    if (isActive != null) data['isActive'] = isActive;
    if (imageUrl != null) data['imageUrl'] = imageUrl;

    return data;
  }
}
