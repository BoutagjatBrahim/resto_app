# Backend RestoBook

## Architecture du backend

```
backend/
├── config/         # Fichiers de configuration (ex: database.js)
├── middleware/     # Middlewares (authentification, CORS, etc.)
├── routes/         # Routes API (auth, menu, reservations)
├── database.sql    # Script SQL pour la base de données
├── init-db.js      # Script d'initialisation DB
├── package.json    # Dépendances Node.js
├── server.js       # Point d'entrée du serveur Express
└── readme.md       # Ce fichier
```

## Lancer le backend

1. **Configurer la base de données**
   - Exécutez le script d'initialisation :
     ```powershell
     cd backend
     npm run init-db
     ```
   (Ce script crée la base et importe le schéma automatiquement)

2. **Configurer les variables d'environnement**
   - Copiez `.env.example` en `.env` (si présent) et adaptez les paramètres DB.

3. **Installer les dépendances**
   ```powershell
   npm install
   ```

4. **Lancer le serveur**
   ```powershell
   npm run dev
   ```
   L'API sera accessible sur http://localhost:3000

---

Pour plus de détails, voir les fichiers dans chaque dossier du backend.
