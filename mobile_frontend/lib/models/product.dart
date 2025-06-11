class Product {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final String currency;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    required this.currency,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['thumbnail']?['url'],
      price:
          double.tryParse(
            json['pricing']?['priceRange']?['start']?['gross']?['amount']
                    ?.toString() ??
                '0',
          ) ??
          0.0,
      currency:
          json['pricing']?['priceRange']?['start']?['gross']?['currency'] ??
          'USD',
    );
  }
}
