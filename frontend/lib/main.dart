import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/my_reservations_screen.dart';
import 'screens/manage_reservations_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init(); // Initialiser l'authentification
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resto Réservation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/reservations': (context) => ReservationScreen(),
        '/manage-reservations': (context) => ManageReservationsScreen(),
        '/menu': (context) => MenuScreen(),
        '/my-reservations': (context) => MyReservationsScreen(),
      },
    );
  }
}
