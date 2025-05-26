// models/user.dart
class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.role = 'client',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone']?.toString(),
      role: json['role'] ?? 'client',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isServeur => role == 'serveur';
  bool get isClient => role == 'client';
}
