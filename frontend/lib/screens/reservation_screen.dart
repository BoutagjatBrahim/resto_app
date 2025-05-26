// screens/reservation_screen.dart
import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/auth_service.dart';
import '../services/reservation_service.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialRequestsController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  int _numberOfPeople = 2;
  bool _isLoading = false;
  Map<String, int> _availableSlots = {};

  @override
  void initState() {
    super.initState();
    // Pré-remplir avec les infos de l'utilisateur connecté
    if (AuthService.currentUser != null) {
      _nameController.text = AuthService.currentUser!.name;
      _phoneController.text = AuthService.currentUser!.phone ?? '';
    }
    _loadAvailableSlots();
  }

  void _loadAvailableSlots() async {
    final timeSlots = ReservationService.getTimeSlots();
    Map<String, int> slots = {};

    for (String time in timeSlots) {
      final available = await ReservationService.getAvailableSlots(
        _selectedDate,
        time,
      );
      slots[time] = available;
    }

    setState(() {
      _availableSlots = slots;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null;
      });
      _loadAvailableSlots();
    }
  }

  void _submitReservation() async {
    if (_formKey.currentState!.validate() && _selectedTime != null) {
      setState(() {
        _isLoading = true;
      });

      final reservation = Reservation(
        userId: AuthService.currentUser!.id,
        date: _selectedDate,
        time: _selectedTime!,
        numberOfPeople: _numberOfPeople,
        specialRequests: _specialRequestsController.text,
        phone: _phoneController.text,
        name: _nameController.text,
      );

      final result = await ReservationService.createReservation(reservation);

      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Réservation confirmée !'),
                content: Text(
                  'Votre table pour $_numberOfPeople personne(s) est réservée le ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} à $_selectedTime.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Désolé, plus de places disponibles pour ce créneau'),
          ),
        );
      }
    } else if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner un créneau horaire')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Réserver une table')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Téléphone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro de téléphone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Date
              ListTile(
                title: Text('Date de réservation'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.calendar_today, color: Colors.orange),
                onTap: () => _selectDate(context),
                tileColor: Colors.orange.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.orange.shade200),
                ),
              ),
              SizedBox(height: 20),

              // Nombre de personnes
              Text(
                'Nombre de personnes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: List.generate(8, (index) {
                  final count = index + 1;
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text('$count'),
                      selected: _numberOfPeople == count,
                      onSelected: (selected) {
                        setState(() {
                          _numberOfPeople = count;
                        });
                        _loadAvailableSlots();
                      },
                      selectedColor: Colors.orange,
                      labelStyle: TextStyle(
                        color:
                            _numberOfPeople == count
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),

              // Créneaux horaires
              Text(
                'Créneau horaire',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    ReservationService.getTimeSlots().map((time) {
                      final available = _availableSlots[time] ?? 0;
                      final isAvailable = available > 0;
                      final isSelected = _selectedTime == time;

                      return ChoiceChip(
                        label: Text(
                          '$time\n($available places)',
                          textAlign: TextAlign.center,
                        ),
                        selected: isSelected,
                        onSelected:
                            isAvailable
                                ? (selected) {
                                  setState(() {
                                    _selectedTime = selected ? time : null;
                                  });
                                }
                                : null,
                        backgroundColor:
                            isAvailable ? null : Colors.grey.shade300,
                        selectedColor: Colors.orange,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
              ),
              SizedBox(height: 20),

              // Demandes spéciales
              TextFormField(
                controller: _specialRequestsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Demandes spéciales (optionnel)',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                  hintText: 'Allergies, préférences, occasions spéciales...',
                ),
              ),
              SizedBox(height: 30),

              // Bouton de réservation
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitReservation,
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Confirmer la réservation',
                            style: TextStyle(fontSize: 18),
                          ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }
}
