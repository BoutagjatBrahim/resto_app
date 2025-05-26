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
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      date: DateTime.parse(json['date']).toLocal(),
      time: json['time'] ?? '',
      numberOfPeople: json['number_of_people'] ?? 1,
      specialRequests: json['special_requests']?.toString(),
      status: json['status'] ?? 'pending',
      phone: json['phone']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'time': time,
      'number_of_people': numberOfPeople,
      'special_requests': specialRequests,
      'status': status,
      'phone': phone,
      'name': name,
    };
  }
}
