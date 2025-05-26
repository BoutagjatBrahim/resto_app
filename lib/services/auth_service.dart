// services/auth_service.dart
import '../models/user.dart';

class AuthService {
  static User? _currentUser;
  static final Map<String, User> _users = {};

  static User? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;

  static Future<User?> login(String email, String password) async {
    // Simulation d'une API
    await Future.delayed(Duration(seconds: 1));
    
    // Vérifier si l'utilisateur existe
    final user = _users[email];
    if (user != null) {
      _currentUser = user;
      return user;
    }
    
    return null;
  }

  static Future<User?> register(String email, String password, String name) async {
    // Simulation d'une API
    await Future.delayed(Duration(seconds: 1));
    
    // Créer un nouvel utilisateur
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );
    
    _users[email] = newUser;
    _currentUser = newUser;
    
    return newUser;
  }

  static void logout() {
    _currentUser = null;
  }
}