// models/user.dart
class User {
  final String id;
  final String email;
  final String name;
  final String? phone;

  User({required this.id, required this.email, required this.name, this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'phone': phone};
  }
}
