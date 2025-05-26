// services/menu_service.dart
import '../models/menu_item.dart';

class MenuService {
  static final List<MenuItem> _menuItems = [
    // Entrées
    MenuItem(
      id: '1',
      name: 'Salade César',
      description: 'Salade romaine, parmesan, croûtons, sauce César',
      price: 12.50,
      category: 'Entrées',
    ),
    MenuItem(
      id: '2',
      name: 'Soupe à l\'oignon',
      description: 'Soupe traditionnelle gratinée au fromage',
      price: 9.00,
      category: 'Entrées',
    ),
    MenuItem(
      id: '3',
      name: 'Carpaccio de bœuf',
      description: 'Fines tranches de bœuf, roquette, parmesan',
      price: 14.00,
      category: 'Entrées',
    ),
    
    // Plats
    MenuItem(
      id: '4',
      name: 'Bœuf Bourguignon',
      description: 'Bœuf mijoté au vin rouge, légumes',
      price: 24.00,
      category: 'Plats',
    ),
    MenuItem(
      id: '5',
      name: 'Saumon grillé',
      description: 'Saumon, légumes de saison, beurre citronné',
      price: 22.00,
      category: 'Plats',
    ),
    MenuItem(
      id: '6',
      name: 'Risotto aux champignons',
      description: 'Risotto crémeux, champignons, parmesan',
      price: 18.00,
      category: 'Plats',
    ),
    
    // Desserts
    MenuItem(
      id: '7',
      name: 'Crème brûlée',
      description: 'Crème vanillée, caramel croquant',
      price: 8.00,
      category: 'Desserts',
    ),
    MenuItem(
      id: '8',
      name: 'Fondant au chocolat',
      description: 'Cœur coulant, glace vanille',
      price: 9.00,
      category: 'Desserts',
    ),
  ];

  static Future<List<MenuItem>> getMenuItems() async {
    // Simulation d'une API
    await Future.delayed(Duration(milliseconds: 500));
    return _menuItems;
  }

  static List<String> getCategories() {
    return _menuItems.map((item) => item.category).toSet().toList();
  }
}