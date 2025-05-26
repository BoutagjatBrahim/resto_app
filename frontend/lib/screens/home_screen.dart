// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Utiliser un Consumer ou StatefulWidget si des mises à jour de l'UI en temps réel sont nécessaires
    // pour le statut de connexion, mais pour un simple StatelessWidget, on se base sur l'état actuel.
    final isLoggedIn = AuthService.isLoggedIn;
    final currentUser = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Le Gourmet'),
        actions: [
          if (isLoggedIn)
            TextButton.icon(
              icon: Icon(Icons.logout),
              label: Text('Déconnexion'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                AuthService.logout();
                // Naviguer vers une page qui forcera le rebuild ou simplement rafraîchir
                // Pour l'instant, je renvoie à l'accueil qui va se reconstruire
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          else
            TextButton.icon(
              icon: Icon(Icons.login),
              label: Text('Connexion'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade100, Colors.orange.shade50],
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
                  style: TextStyle(fontSize: 16, color: Colors.brown.shade600),
                ),
                SizedBox(height: 40),

                // Bouton Menu (visible pour tous)
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

                // Boutons Réservation et Mes Réservations (visibles seulement pour les clients connectés)
                if (isLoggedIn && currentUser != null && currentUser.isClient)
                  Column(
                    children: [
                      // Bouton Réservation
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/reservations');
                        },
                        icon: Icon(Icons.calendar_today),
                        label: Text('Réserver une Table'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            166,
                            237,
                            169,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Bouton Mes Réservations
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/my-reservations');
                        },
                        icon: Icon(Icons.list_alt),
                        label: Text('Mes Réservations'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            148,
                            197,
                            238,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ), // Espace après les boutons de réservation
                    ],
                  ),

                // Afficher le nom de l'utilisateur connecté et le bouton Gérer Réservations
                if (isLoggedIn && currentUser != null)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Text(
                          'Connecté en tant que: ${currentUser.name}',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.brown.shade600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Rôle: ${currentUser.role}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown.shade400,
                          ),
                        ),
                        if (currentUser.isServeur || currentUser.isAdmin)
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/manage-reservations',
                                );
                              },
                              icon: Icon(Icons.calendar_today),
                              label: Text('Gérer les réservations'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                      ],
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
