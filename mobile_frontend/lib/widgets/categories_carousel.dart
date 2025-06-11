import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoriesCarousel extends StatelessWidget {
  final List<Category> categories;

  const CategoriesCarousel({Key? key, required this.categories})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                // Navigate to category page
                print('Tapped on category: ${category.name}');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min, // Important: Use min size
                children: [
                  Expanded(
                    // Use Expanded to prevent overflow
                    flex: 3,
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                        image:
                            category.backgroundImageUrl != null
                                ? DecorationImage(
                                  image: NetworkImage(
                                    category.backgroundImageUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          category.backgroundImageUrl == null
                              ? Icon(
                                Icons.category,
                                size: 30,
                                color: Colors.grey[600],
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    // Use Expanded for text to prevent overflow
                    flex: 1,
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
