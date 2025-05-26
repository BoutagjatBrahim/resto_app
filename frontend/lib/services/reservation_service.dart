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
      print('Données brutes des réservations: $data');
      return data.map((item) => Reservation.fromJson(item)).toList();
    }
    throw Exception('Failed to load reservations');
  }

  static Future<void> createReservation(Reservation reservation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations'),
      headers: _headers,
      body: jsonEncode({
        'date': reservation.date.toIso8601String().split('T')[0],
        'time': reservation.time,
        'number_of_people': reservation.numberOfPeople,
        'special_requests': reservation.specialRequests,
        'phone': reservation.phone,
        'name': reservation.name,
      }),
    );

    print(
      'Statut de la réponse de création de réservation : ${response.statusCode}',
    );
    print('Corps de la réponse de création de réservation : ${response.body}');

    if (response.statusCode == 201) {
      // Création réussie, pas besoin de parser la réponse en objet Reservation complet
      // puisque le backend ne renvoie que l'ID et un message.
      // L'écran de destination (Mes Réservations) rechargera la liste complète.
      return; // Indique le succès sans retourner d'objet Reservation
    } else {
      // Gérer les autres codes d'erreur du backend
      String errorMessage =
          'Erreur inconnue lors de la création de la réservation.';
      try {
        final errorJson = jsonDecode(response.body);
        if (errorJson.containsKey('error')) {
          errorMessage = errorJson['error'];
        } else if (response.body.isNotEmpty) {
          errorMessage =
              response
                  .body; // Utiliser le corps entier si pas d'erreur formatée
        }
      } catch (e) {
        // Ignorer les erreurs de parsing si le corps n'est pas JSON
        if (response.body.isNotEmpty) {
          errorMessage =
              response
                  .body; // Utiliser le corps entier si pas d'erreur formatée
        }
      }
      throw Exception(errorMessage);
    }
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
    print(
      'Requête d'
      'availability pour la date : $dateStr',
    );
    final response = await http.get(
      Uri.parse('$baseUrl/reservations/availability/$dateStr'),
      headers: _headers,
    );

    print(
      'Statut de la réponse d'
      'availability : ${response.statusCode}',
    );
    print(
      'Corps de la réponse d'
      'availability : ${response.body}',
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

  static Future<List<Reservation>> getAllReservations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservations/all'),
      headers: AuthService.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Reservation.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch all reservations');
  }

  static Future<void> updateReservationStatus(String id, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/reservations/$id/status'),
      headers: AuthService.headers,
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update reservation status');
    }
  }
}
