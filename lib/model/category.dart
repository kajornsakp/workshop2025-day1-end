class Category {
  final String? id;
  final String name;
  final String? description;

  Category({
    this.id,
    required this.name,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
    };

    if (id != null) data['id'] = id;
    if (description != null) data['description'] = description;

    return data;
  }
}
