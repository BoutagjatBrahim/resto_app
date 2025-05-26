// screens/my_reservations_screen.dart
import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/auth_service.dart';
import '../services/reservation_service.dart';

class MyReservationsScreen extends StatefulWidget {
  @override
  _MyReservationsScreenState createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  List<Reservation> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() async {
    if (AuthService.currentUser != null) {
      final reservations = await ReservationService.getUserReservations(
        AuthService.currentUser!.id,
      );
      setState(() {
        _reservations = reservations;
        _isLoading = false;
      });
    }
  }

  void _cancelReservation(String reservationId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler la réservation'),
        content: Text('Êtes-vous sûr de vouloir annuler cette réservation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Oui', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ReservationService.cancelReservation(reservationId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réservation annulée avec succès')),
        );
        _loadReservations();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Réservations'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _reservations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 100,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Aucune réservation',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/reservation');
                        },
                        child: Text('Faire une réservation'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = _reservations[index];
                    final isPast = reservation.date.isBefore(DateTime.now());
                    final statusColor = reservation.status == 'confirmed'
                        ? Colors.green
                        : reservation.status == 'cancelled'
                            ? Colors.red
                            : Colors.orange;

                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        leading: CircleAvatar(
                          backgroundColor: statusColor.withOpacity(0.2),
                          child: Icon(
                            reservation.status == 'confirmed'
                                ? Icons.check_circle
                                : reservation.status == 'cancelled'
                                    ? Icons.cancel
                                    : Icons.schedule,
                            color: statusColor,
                          ),
                        ),
                        title: Text(
                          '${reservation.date.day}/${reservation.date.month}/${reservation.date.year} à ${reservation.time}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text('${reservation.numberOfPeople} personne(s)'),
                            if (reservation.specialRequests != null &&
                                reservation.specialRequests!.isNotEmpty)
                              Text(
                                'Note: ${reservation.specialRequests}',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                reservation.status == 'confirmed'
                                    ? 'Confirmée'
                                    : reservation.status == 'cancelled'
                                        ? 'Annulée'
                                        : 'En attente',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: reservation.status == 'confirmed' && !isPast
                            ? IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => _cancelReservation(reservation.id!),
                              )
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}