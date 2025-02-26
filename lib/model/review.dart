class Review {
  final String? id;
  final String? userId;
  final String productId;
  final double rating;
  final String? comment;
  final DateTime? createdAt;

  Review({
    this.id,
    this.userId,
    required this.productId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'productId': productId,
      'rating': rating,
    };

    if (comment != null) data['comment'] = comment;

    return data;
  }
}
