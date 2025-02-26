class User {
  final String? id;
  final String email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final String? photoURL;
  final String? role;

  User({
    this.id,
    required this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.displayName,
    this.photoURL,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['uid'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
    };

    if (password != null) data['password'] = password;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (displayName != null) data['displayName'] = displayName;
    if (photoURL != null) data['photoURL'] = photoURL;
    if (role != null) data['role'] = role;

    return data;
  }
}
