import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl =
      'http://localhost:3000/api'; // Change pour ton IP en production
  static String? _token;
  static bool _initialized = false;
  static User? _currentUser;

  static User? get currentUser => _currentUser;

  static Future<void> init() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _initialized = true;
  }

  static bool get isLoggedIn => _token != null;

  static void setToken(String? token) {
    _token = token;
    _saveToken(token);
  }

  static Future<void> _saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('auth_token', token);
    } else {
      await prefs.remove('auth_token');
    }
  }

  static String? get token => _token;

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setToken(data['token']);
      _currentUser = User.fromJson(data['user']);
      return data;
    }
    throw Exception(jsonDecode(response.body)['error']);
  }

  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
    String? phone,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setToken(data['token']);
      _currentUser = User.fromJson(data['user']);
      return data;
    }
    throw Exception(jsonDecode(response.body)['error']);
  }

  static void logout() {
    _token = null;
    _currentUser = null;
    _saveToken(null);
  }

  static bool isAuthenticated() {
    return _token != null;
  }
}
