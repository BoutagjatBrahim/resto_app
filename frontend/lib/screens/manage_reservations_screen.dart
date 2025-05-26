import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/auth_service.dart';
import '../services/reservation_service.dart';

class ManageReservationsScreen extends StatefulWidget {
  @override
  _ManageReservationsScreenState createState() =>
      _ManageReservationsScreenState();
}

class _ManageReservationsScreenState extends State<ManageReservationsScreen> {
  List<Reservation> _reservations = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final reservations = await ReservationService.getAllReservations();
      setState(() {
        _reservations = reservations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des réservations: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateReservationStatus(String id, String status) async {
    try {
      await ReservationService.updateReservationStatus(id, status);
      await _loadReservations(); // Recharger la liste
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Statut de la réservation mis à jour')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour: $e')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des réservations'),
        backgroundColor: Colors.orange,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
              ? Center(child: Text(_error, style: TextStyle(color: Colors.red)))
              : RefreshIndicator(
                onRefresh: _loadReservations,
                child: ListView.builder(
                  itemCount: _reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = _reservations[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${reservation.name}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(reservation.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    reservation.status.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date: ${reservation.date.toString().split(' ')[0]}',
                            ),
                            Text('Heure: ${reservation.time}'),
                            Text('Personnes: ${reservation.numberOfPeople}'),
                            if (reservation.specialRequests != null)
                              Text(
                                'Demandes spéciales: ${reservation.specialRequests}',
                              ),
                            SizedBox(height: 16),
                            if (reservation.status == 'pending')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed:
                                        () => _updateReservationStatus(
                                          reservation.id!,
                                          'cancelled',
                                        ),
                                    child: Text('Refuser'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed:
                                        () => _updateReservationStatus(
                                          reservation.id!,
                                          'confirmed',
                                        ),
                                    child: Text('Confirmer'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
