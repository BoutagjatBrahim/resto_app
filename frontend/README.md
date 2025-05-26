🍽️ RestoBook - Application de Réservation Restaurant

Une application mobile Flutter permettant aux clients de consulter le menu d'un restaurant et de réserver une table, avec une interface de gestion pour les hôtes.


📱 Aperçu du Projet

RestoBook est une solution complète de réservation de restaurant comprenant :

Application mobile Flutter pour les clients
API REST pour la gestion des données
Interface back-office pour les hôtes du restaurant

🎯 Fonctionnalités Principales

Pour les Clients :

✅ Consultation du menu restaurant
✅ Sélection de date et heure pour réservation
✅ Formulaire de réservation (nom, téléphone, nombre de couverts)
✅ Création de compte et connexion
✅ Gestion de ses réservations (modification/annulation)
✅ Confirmation de réservation

Pour les Hôtes :

✅ Consultation de toutes les réservations
✅ Validation/refus des demandes de réservation
✅ Gestion des créneaux et disponibilités

🛠️ Technologies Utilisées

Frontend : Flutter (Dart 3.0+)
Backend : Node.js + Express.js (ou PHP selon votre choix)
Base de données : MySQL
Authentification : JWT (JSON Web Tokens)
Gestion d'état : Provider (ou votre solution préférée)

📁 Structure du Projet
resto-book/
├── frontend/                 # Application Flutter
│   ├── lib/
│   │   ├── screens/         # Écrans de l'application
│   │   ├── widgets/         # Composants réutilisables
│   │   ├── models/          # Modèles de données
│   │   ├── services/        # Services API
│   │   └── utils/           # Utilitaires
│   ├── assets/              # Images et ressources
│   └── pubspec.yaml
├── backend/                 # API REST
│   ├── routes/              # Routes API
│   ├── models/              # Modèles base de données
│   ├── middleware/          # Middleware (auth, CORS)
│   ├── config/              # Configuration
│   └── server.js
├── database/                # Scripts SQL
│   ├── schema.sql           # Structure base de données
│   └── dump.sql             # Données de test
└── README.md


🚀 Installation et Lancement

Prérequis

Flutter SDK (≥ 3.0)
Node.js (≥ 16.0) (ou PHP/Apache)
MySQL
Android Studio / VS Code

1. Configuration de la Base de Données
bash# Créer la base de données
mysql -u root -p
CREATE DATABASE restaurant_reservations;

# Importer le schéma
mysql -u root -p restaurant_reservations < database/schema.sql

# (Optionnel) Importer les données de test
mysql -u root -p restaurant_reservations < database/dump.sql
2. Configuration du Backend
bash# Aller dans le dossier backend
cd backend

# Installer les dépendances
npm install

# Configurer les variables d'environnement
cp .env.example .env
# Éditer .env avec vos paramètres de base de données

# Lancer le serveur
npm start
Le serveur API est accessible sur http://localhost:3000

3. Configuration du Frontend Flutter
bash# Aller dans le dossier frontend
cd frontend

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

🔧 Configuration

Variables d'Environnement (.env)
envDB_HOST=localhost
DB_PORT=3306
DB_NAME=restaurant_reservations
DB_USER=root
DB_PASSWORD=your_password
JWT_SECRET=your_jwt_secret_key
PORT=3000


Configuration Flutter

Modifiez l'URL de l'API dans lib/services/api_service.dart :
dartstatic const String baseUrl = 'http://your-api-url:3000';


📊 Base de Données

Tables Principales

users : Gestion des comptes utilisateurs
reservations : Stockage des réservations
menu_items : Articles du menu restaurant
time_slots : Créneaux horaires disponibles

Voir database/schema.sql pour la structure complète.

🔐 Authentification

L'application utilise JWT pour l'authentification :

Les tokens sont stockés localement sur l'appareil
Expiration automatique après 24h
Refresh token pour maintenir la session


🧪 Comptes de Test
Client

Email : client@test.com
Mot de passe : password123


Hôte/Admin

Email : admin@restaurant.com
Mot de passe : admin123

📱 Captures d'Écran
[Ajoutez ici vos captures d'écran de l'application]
Écran d'Accueil
Afficher l'image
Menu Restaurant
Afficher l'image
Réservation
Afficher l'image
Back-Office
Afficher l'image


🎥 Démonstration

Lien vers la vidéo de démonstration


📋 API Endpoints

Authentification

POST /api/auth/register - Inscription
POST /api/auth/login - Connexion

Réservations

GET /api/reservations - Liste des réservations
POST /api/reservations - Créer une réservation
PUT /api/reservations/:id - Modifier une réservation
DELETE /api/reservations/:id - Supprimer une réservation

Menu

GET /api/menu - Récupérer le menu

Disponibilités

GET /api/availability/:date - Vérifier disponibilités

🐛 Problèmes Connus et Solutions
Erreur CORS :
Si vous rencontrez des erreurs CORS, vérifiez la configuration dans backend/middleware/cors.js

Connexion Base de Données:
Assurez-vous que MySQL est démarré et que les paramètres de connexion sont corrects dans .env


Hot Reload Flutter :
En cas de problème avec le hot reload, utilisez flutter clean puis flutter pub get
🤝 Équipe de Développement

[Nom Membre 1] - Frontend Flutter, UI/UX
[Nom Membre 2] - Backend API, Base de données
[Nom Membre 3] - Authentification, Sécurité
[Nom Membre 4] - Tests, Documentation, DevOps

📈 Évolutions Futures

 Notifications push
 Intégration paiement en ligne
 Système de fidélité
 Application web responsive
 Géolocalisation restaurant
 Avis et notation clients

📄 Licence
Ce projet est développé dans le cadre d'un projet éducatif.

📞 Support
Pour toute question ou problème, contactez l'équipe de développement via [votre-email@example.com].