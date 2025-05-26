// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Le Gourmet'),
        actions: [
          if (AuthService.isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                AuthService.logout();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade100,
              Colors.orange.shade50,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 100,
                  color: Colors.orange.shade700,
                ),
                SizedBox(height: 20),
                Text(
                  'Bienvenue au Restaurant Le Gourmet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Cuisine française traditionnelle',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown.shade600,
                  ),
                ),
                SizedBox(height: 40),
                
                // Bouton Menu
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                  icon: Icon(Icons.menu_book),
                  label: Text('Voir le Menu'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                
                // Bouton Réservation
                ElevatedButton.icon(
                  onPressed: () {
                    if (AuthService.isLoggedIn) {
                      Navigator.pushNamed(context, '/reservation');
                    } else {
                      Navigator.pushNamed(context, '/login');
                    }
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text('Réserver une Table'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                
                // Bouton Mes Réservations
                if (AuthService.isLoggedIn)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/my-reservations');
                    },
                    icon: Icon(Icons.list_alt),
                    label: Text('Mes Réservations'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                
                // Afficher le nom de l'utilisateur connecté
                if (AuthService.isLoggedIn && AuthService.currentUser != null)
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      'Connecté en tant que: ${AuthService.currentUser!.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}