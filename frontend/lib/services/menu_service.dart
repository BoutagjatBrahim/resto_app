import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';
import 'auth_service.dart';

class MenuService {
  static const String baseUrl = 'http://localhost:3000/api'; // Change pour ton IP en production

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
  };

  static Future<List<MenuItem>> getMenuItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/menu'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => MenuItem.fromJson(item)).toList();
    }
    throw Exception('Failed to load menu');
  }

  static Future<MenuItem> getMenuItem(String itemId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/menu/$itemId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return MenuItem.fromJson(data);
    }
    throw Exception('Failed to load menu item');
  }

  static Future<List<MenuItem>> getMenuByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/menu/category/$category'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => MenuItem.fromJson(item)).toList();
    }
    throw Exception('Failed to load menu items by category');
  }
}