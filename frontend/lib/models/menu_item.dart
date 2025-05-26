// models/menu_item.dart
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? imageUrl;
  final int available;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.available,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    // Tente de parser le prix comme un double, gère les cas où c'est un int ou une string.
    final priceValue = json['price'];
    double parsedPrice = 0.0;
    if (priceValue is num) {
      parsedPrice = priceValue.toDouble();
    } else if (priceValue is String) {
      parsedPrice = double.tryParse(priceValue) ?? 0.0;
    }

    return MenuItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: parsedPrice, // Utiliser le prix parsé
      category: json['category'] ?? '',
      imageUrl: json['image_url'],
      available: json['available'] ?? 0,
    );
  }
}
