-- Créer la base de données si elle n'existe pas
CREATE DATABASE IF NOT EXISTS resto_app;
USE resto_app;

-- Supprimer les tables existantes pour repartir de zéro
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS users;

-- Table des utilisateurs
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des réservations
CREATE TABLE reservations (
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
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table du menu
CREATE TABLE menu_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  category VARCHAR(100) NOT NULL,
  image_url VARCHAR(500),
  available BOOLEAN DEFAULT TRUE
);

-- Insérer des utilisateurs de test
-- Mot de passe: 123456 (hashé avec bcrypt)
INSERT INTO users (name, email, password, phone) VALUES
('Jean Dupont', 'jean@test.com', '$2a$10$YourHashHere', '0612345678'),
('Marie Martin', 'marie@test.com', '$2a$10$YourHashHere', '0687654321'),
('Test User', 'test@test.com', '$2a$10$rBYLz7e8Xp1xC3FPfKyRgO0Dc7iVYkHwYxLWKMxKqQYqx8yPjmqWe', '0600000000');

-- Insérer le menu complet
INSERT INTO menu_items (name, description, price, category) VALUES
-- Entrées
('Salade César', 'Salade romaine, parmesan, croûtons, sauce César maison', 12.50, 'Entrées'),
('Soupe à l\'oignon gratinée', 'Soupe traditionnelle gratinée au fromage Gruyère', 9.00, 'Entrées'),
('Carpaccio de bœuf', 'Fines tranches de bœuf, roquette, parmesan, huile d\'olive', 14.00, 'Entrées'),
('Foie gras maison', 'Servi avec confiture de figues et toasts briochés', 18.00, 'Entrées'),
('Escargots de Bourgogne', '6 escargots au beurre persillé', 13.00, 'Entrées'),
('Tartare de saumon', 'Saumon frais, avocat, agrumes, coriandre', 15.00, 'Entrées'),

-- Plats principaux
('Bœuf Bourguignon', 'Bœuf mijoté au vin rouge, carottes, champignons, pommes vapeur', 24.00, 'Plats'),
('Saumon grillé', 'Saumon Label Rouge, légumes de saison, beurre citronné', 22.00, 'Plats'),
('Risotto aux champignons', 'Risotto crémeux, cèpes, parmesan, truffe', 18.00, 'Plats'),
('Côte de bœuf (400g)', 'Viande maturée, frites maison, sauce béarnaise', 32.00, 'Plats'),
('Magret de canard', 'Sauce au miel et vinaigre balsamique, gratin dauphinois', 26.00, 'Plats'),
('Filet de bar', 'En croûte d\'herbes, purée de patates douces, légumes croquants', 28.00, 'Plats'),
('Poulet fermier rôti', 'Pommes de terre grenailles, jus au thym', 19.00, 'Plats'),
('Lasagnes végétariennes', 'Légumes de saison, béchamel, mozzarella', 16.00, 'Plats'),

-- Desserts
('Crème brûlée', 'Crème vanillée, caramel croquant', 8.00, 'Desserts'),
('Fondant au chocolat', 'Cœur coulant, glace vanille de Madagascar', 9.00, 'Desserts'),
('Tarte tatin', 'Pommes caramélisées, pâte feuilletée, crème fraîche', 8.50, 'Desserts'),
('Profiteroles', 'Choux garnis de glace vanille, sauce chocolat chaud', 9.50, 'Desserts'),
('Tiramisu', 'Recette traditionnelle au café et mascarpone', 7.50, 'Desserts'),
('Café gourmand', 'Expresso accompagné de 3 mignardises', 8.00, 'Desserts'),

-- Boissons
('Eau minérale (50cl)', 'Evian ou Badoit', 3.50, 'Boissons'),
('Coca-Cola', '33cl', 4.00, 'Boissons'),
('Jus de fruits', 'Orange, pomme ou ananas', 4.50, 'Boissons'),
('Café', 'Expresso, allongé ou décaféiné', 2.50, 'Boissons'),
('Thé', 'Earl Grey, menthe ou fruits rouges', 3.00, 'Boissons'),
('Verre de vin', 'Rouge, blanc ou rosé', 6.00, 'Boissons');

-- Insérer des réservations de test
INSERT INTO reservations (user_id, date, time, number_of_people, special_requests, status, phone, name) VALUES
(1, CURDATE() + INTERVAL 1 DAY, '19:00', 2, 'Table près de la fenêtre si possible', 'confirmed', '0612345678', 'Jean Dupont'),
(1, CURDATE() + INTERVAL 3 DAY, '20:00', 4, 'Anniversaire, prévoir un dessert avec bougie', 'confirmed', '0612345678', 'Jean Dupont'),
(2, CURDATE() + INTERVAL 2 DAY, '12:30', 3, 'Un enfant de 5 ans, besoin chaise haute', 'confirmed', '0687654321', 'Marie Martin'),
(2, CURDATE() - INTERVAL 1 DAY, '19:30', 2, NULL, 'confirmed', '0687654321', 'Marie Martin'),
(1, CURDATE() - INTERVAL 5 DAY, '20:00', 6, 'Repas d\'affaires', 'cancelled', '0612345678', 'Jean Dupont'),
(3, CURDATE() + INTERVAL 7 DAY, '13:00', 2, 'Allergie aux fruits de mer', 'pending', '0600000000', 'Test User');

-- Créer un utilisateur admin (optionnel)
INSERT INTO users (name, email, password, phone) VALUES
('Admin Restaurant', 'admin@resto.com', '$2a$10$rBYLz7e8Xp1xC3FPfKyRgO0Dc7iVYkHwYxLWKMxKqQYqx8yPjmqWe', '0100000000');

-- Afficher les statistiques
SELECT 'Données insérées avec succès!' as Message;
SELECT COUNT(*) as 'Nombre d\'utilisateurs' FROM users;
SELECT COUNT(*) as 'Nombre de plats au menu' FROM menu_items;
SELECT COUNT(*) as 'Nombre de réservations' FROM reservations;