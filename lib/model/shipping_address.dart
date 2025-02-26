class ShippingAddress {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String? country;

  ShippingAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };

    if (country != null) data['country'] = country;

    return data;
  }
}
