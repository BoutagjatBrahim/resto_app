// services/reservation_service.dart
import '../models/reservation.dart';

class ReservationService {
  static final List<Reservation> _reservations = [];
  static final Map<String, int> _availableSlots = {
    '12:00': 20,
    '12:30': 20,
    '13:00': 20,
    '13:30': 20,
    '19:00': 20,
    '19:30': 20,
    '20:00': 20,
    '20:30': 20,
    '21:00': 20,
  };

  static Future<List<Reservation>> getUserReservations(String userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return _reservations.where((r) => r.userId == userId).toList();
  }

  static Future<Reservation?> createReservation(Reservation reservation) async {
    await Future.delayed(Duration(seconds: 1));
    
    // Vérifier la disponibilité
    final key = '${reservation.date.toString().split(' ')[0]}_${reservation.time}';
    final usedSlots = _reservations
        .where((r) => 
            r.date.toString().split(' ')[0] == reservation.date.toString().split(' ')[0] &&
            r.time == reservation.time &&
            r.status != 'cancelled')
        .fold(0, (sum, r) => sum + r.numberOfPeople);
    
    final availableSlots = _availableSlots[reservation.time] ?? 0;
    
    if (usedSlots + reservation.numberOfPeople > availableSlots) {
      return null; // Pas assez de places
    }
    
    final newReservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: reservation.userId,
      date: reservation.date,
      time: reservation.time,
      numberOfPeople: reservation.numberOfPeople,
      specialRequests: reservation.specialRequests,
      status: 'confirmed',
      phone: reservation.phone,
      name: reservation.name,
    );
    
    _reservations.add(newReservation);
    return newReservation;
  }

  static Future<bool> cancelReservation(String reservationId) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      _reservations[index] = Reservation(
        id: _reservations[index].id,
        userId: _reservations[index].userId,
        date: _reservations[index].date,
        time: _reservations[index].time,
        numberOfPeople: _reservations[index].numberOfPeople,
        specialRequests: _reservations[index].specialRequests,
        status: 'cancelled',
        phone: _reservations[index].phone,
        name: _reservations[index].name,
      );
      return true;
    }
    return false;
  }

  static Future<int> getAvailableSlots(DateTime date, String time) async {
    await Future.delayed(Duration(milliseconds: 200));
    
    final usedSlots = _reservations
        .where((r) => 
            r.date.toString().split(' ')[0] == date.toString().split(' ')[0] &&
            r.time == time &&
            r.status != 'cancelled')
        .fold(0, (sum, r) => sum + r.numberOfPeople);
    
    final totalSlots = _availableSlots[time] ?? 0;
    return totalSlots - usedSlots;
  }

  static List<String> getTimeSlots() {
    return _availableSlots.keys.toList();
  }
}