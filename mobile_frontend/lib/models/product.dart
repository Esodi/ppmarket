class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final gross = json['pricing']['priceRange']['start']['gross'];
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: gross['amount']?.toDouble() ?? 0.0,
      currency: gross['currency'] ?? 'USD',
    );
  }
}
