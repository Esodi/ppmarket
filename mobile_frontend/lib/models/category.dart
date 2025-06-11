class Category {
  final String id;
  final String name;
  final String? backgroundImageUrl;
  final String? slug;

  Category({
    required this.id,
    required this.name,
    this.backgroundImageUrl,
    this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      backgroundImageUrl: json['backgroundImage']?['url'],
    );
  }
}
