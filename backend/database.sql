CREATE DATABASE IF NOT EXISTS resto_app;
USE resto_app;

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des réservations
CREATE TABLE IF NOT EXISTS reservations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  date DATE NOT NULL,
  time VARCHAR(10) NOT NULL,
  number_of_people INT NOT NULL,
  special_requests TEXT,
  status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
  phone VARCHAR(20),
  name VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table du menu
CREATE TABLE IF NOT EXISTS menu_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  category VARCHAR(100) NOT NULL,
  image_url VARCHAR(500),
  available BOOLEAN DEFAULT TRUE
);

-- Insertion de données de test pour le menu
INSERT INTO menu_items (name, description, price, category) VALUES
('Salade César', 'Salade romaine, parmesan, croûtons, sauce César', 12.50, 'Entrées'),
('Soupe à l\'oignon', 'Soupe traditionnelle gratinée au fromage', 9.00, 'Entrées'),
('Carpaccio de bœuf', 'Fines tranches de bœuf, roquette, parmesan', 14.00, 'Entrées'),
('Bœuf Bourguignon', 'Bœuf mijoté au vin rouge, légumes', 24.00, 'Plats'),
('Saumon grillé', 'Saumon, légumes de saison, beurre citronné', 22.00, 'Plats'),
('Risotto aux champignons', 'Risotto crémeux, champignons, parmesan', 18.00, 'Plats'),
('Crème brûlée', 'Crème vanillée, caramel croquant', 8.00, 'Desserts'),
('Fondant au chocolat', 'Cœur coulant, glace vanille', 9.00, 'Desserts');