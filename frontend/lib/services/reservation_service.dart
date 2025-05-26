import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservation.dart';
import 'auth_service.dart';

class ReservationService {
  static const String baseUrl =
      'http://localhost:3000/api'; // Change pour ton IP en production

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (AuthService.token != null)
      'Authorization': 'Bearer ${AuthService.token}',
  };

  static List<String> getTimeSlots() {
    return [
       '12:00', '12:30', '13:00', '13:30', // Déjeuner
      '19:00', '19:30', '20:00', '20:30', '21:00', // Dîner
    ];
  }

  static Future<int> getAvailableSlots(DateTime date, String time) async {
    try {
      final availability = await getAvailability(date);
      final maxCapacity = 20; // Capacité maximale par créneau
      final currentBookings = availability[time] ?? 0;
      return maxCapacity - currentBookings;
    } catch (e) {
      return 0;
    }
  }

  static Future<List<Reservation>> getUserReservations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservations'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Reservation.fromJson(item)).toList();
    }
    throw Exception('Failed to load reservations');
  }

  static Future<Reservation> createReservation(Reservation reservation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations'),
      headers: _headers,
      body: jsonEncode({
        'date': reservation.date.toIso8601String().split('T')[0],
        'time': reservation.time,
        'numberOfPeople': reservation.numberOfPeople,
        'specialRequests': reservation.specialRequests,
        'phone': reservation.phone,
        'name': reservation.name,
      }),
    );

    if (response.statusCode == 200) {
      return Reservation.fromJson(jsonDecode(response.body));
    }
    throw Exception(jsonDecode(response.body)['error']);
  }

  static Future<Reservation> updateReservation(
    String reservationId,
    Reservation reservation,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/reservations/$reservationId'),
      headers: _headers,
      body: jsonEncode({
        'date': reservation.date.toIso8601String().split('T')[0],
        'time': reservation.time,
        'numberOfPeople': reservation.numberOfPeople,
        'specialRequests': reservation.specialRequests,
        'phone': reservation.phone,
        'name': reservation.name,
      }),
    );

    if (response.statusCode == 200) {
      return Reservation.fromJson(jsonDecode(response.body));
    }
    throw Exception(jsonDecode(response.body)['error']);
  }

  static Future<void> cancelReservation(String reservationId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/reservations/$reservationId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel reservation');
    }
  }

  static Future<Map<String, int>> getAvailability(DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];
    final response = await http.get(
      Uri.parse('$baseUrl/reservations/availability/$dateStr'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data.map((key, value) => MapEntry(key, value as int));
    }
    throw Exception('Failed to check availability');
  }

  static Future<List<String>> getAvailableTimeSlots(DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];
    final response = await http.get(
      Uri.parse('$baseUrl/reservations/timeslots/$dateStr'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((slot) => slot.toString()).toList();
    }
    throw Exception('Failed to load available time slots');
  }

  static Future<Reservation> getReservation(String reservationId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservations/$reservationId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Reservation.fromJson(data);
    }
    throw Exception('Failed to load reservation');
  }
}
