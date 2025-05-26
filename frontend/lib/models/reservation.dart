// models/reservation.dart
class Reservation {
  final String? id;
  final String userId;
  final DateTime date;
  final String time;
  final int numberOfPeople;
  final String? specialRequests;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final String? phone;
  final String? name;

  Reservation({
    this.id,
    required this.userId,
    required this.date,
    required this.time,
    required this.numberOfPeople,
    this.specialRequests,
    this.status = 'pending',
    this.phone,
    this.name,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      userId: json['userId'] ?? '',
      date: DateTime.parse(json['date']),
      time: json['time'] ?? '',
      numberOfPeople: json['numberOfPeople'] ?? 1,
      specialRequests: json['specialRequests'],
      status: json['status'] ?? 'pending',
      phone: json['phone'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'time': time,
      'numberOfPeople': numberOfPeople,
      'specialRequests': specialRequests,
      'status': status,
      'phone': phone,
      'name': name,
    };
  }
}