🍽️ Restaurant Le gourmet - Application de Réservation Restaurant

Une application mobile Flutter permettant aux clients de consulter le menu d'un restaurant et de réserver une table, avec une interface de gestion pour les hôtes.



🎯 Fonctionnalités Principales

Pour les Clients :

✅ Création de compte et connexion
✅ Consultation du menu restaurant
✅ Sélection de date et heure pour réservation
✅ Formulaire de réservation (nom, téléphone, date, créneau)
✅ Gestion de ses réservations (annulation uniquement si ce n'est pas aujourd'hui)

Pour les Hôtes :

✅ Consultation de toutes les réservations
✅ Validation/refus des demandes de réservation des clients
✅ Gestion des créneaux et disponibilités (non disponible)



🚀 Installation et Lancement

Prérequis

Flutter SDK (≥ 3.0)
Android Studio / VS Code

1. Lancer le backend (détails dans README du backend)

2. Configuration du Frontend Flutter

bash# Aller dans le dossier frontend
cd frontend

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run


Configuration Flutter (Mode static -> tous les api se lance depuis la base url localhost:3000)

Modifiez l'URL de l'API dans lib/services/api_service.dart :
dartstatic const String baseUrl = 'http://your-api-url:3000';


📊 Base de Données

Tables Principales

users : Gestion des comptes utilisateurs
reservations : Stockage des réservations
menu_items : Articles du menu restaurant

Voir backend pour la structure complète.

🔐 Authentification

L'application utilise JWT pour l'authentification :

Les tokens sont stockés localement sur l'appareil
Expiration automatique après 24h
Refresh token pour maintenir la session


🧪 Comptes de Test
Client

Email : user@test.com
Mot de passe : 123456


Hôte/Serveur

Email : serveur@test.com
Mot de passe : 123456



Connexion Base de Données:
Assurez-vous que MySQL est démarré et que les paramètres de connexion sont corrects dans .env


Hot Reload Flutter :
En cas de problème avec le hot reload, utilisez flutter clean puis flutter pub get
🤝 Équipe de Développement

ELHADIDI Omar
BOUTAGJAT Brahim

📈 Évolutions Futures

 Notifications push
 Intégration paiement en ligne
 Système de fidélité
 Gestions Admin
 Géolocalisation restaurant
 Avis et notation clients

📄 Licence
Ce projet est développé dans le cadre d'un projet éducatif.
