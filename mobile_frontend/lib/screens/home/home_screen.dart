import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/banner.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../services/banner_service.dart';
import '../../services/cart_service.dart';
import '../../services/category_service.dart';
import '../../services/product_service.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/categories_carousel.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<BannerModel>> bannersFuture;
  late Future<List<Category>> categoriesFuture;
  late Future<List<Product>> onSaleFuture;
  late Future<List<Product>> recommendedFuture;

  @override
  void initState() {
    super.initState();
    final banners = context.read<BannerService>();
    final categories = context.read<CategoryService>();
    final products = context.read<ProductService>();
    bannersFuture = banners.fetchBanners();
    categoriesFuture = categories.fetchCategories();
    onSaleFuture = products.fetchOnSaleProducts(limit: 6);
    recommendedFuture = products.fetchRecommendedProducts(limit: 6);
  }

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (cartService.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cartService.itemCount}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            bannersFuture = context.read<BannerService>().fetchBanners();
            categoriesFuture =
                context.read<CategoryService>().fetchCategories();
            onSaleFuture = context.read<ProductService>().fetchOnSaleProducts(
              limit: 6,
            );
            recommendedFuture = context
                .read<ProductService>()
                .fetchRecommendedProducts(limit: 6);
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<BannerModel>>(
                future: bannersFuture,
                builder: (c, s) {
                  if (s.connectionState == ConnectionState.waiting)
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  if (s.hasError || s.data == null) return const SizedBox();
                  return BannerCarousel(banners: s.data!);
                },
              ),
              const SectionHeader(title: 'Categories'),
              FutureBuilder<List<Category>>(
                future: categoriesFuture,
                builder: (c, s) {
                  if (s.connectionState == ConnectionState.waiting)
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  if (s.hasError || s.data == null) return const SizedBox();
                  return CategoriesCarousel(categories: s.data!);
                },
              ),
              const SectionHeader(title: 'On Sale'),
              FutureBuilder<List<Product>>(
                future: onSaleFuture,
                builder: (c, s) {
                  if (s.connectionState == ConnectionState.waiting)
                    return const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  if (s.hasError || s.data == null || s.data!.isEmpty)
                    return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                      itemCount: s.data!.length,
                      itemBuilder:
                          (ctx, idx) => ProductCard(product: s.data![idx]),
                    ),
                  );
                },
              ),
              const SectionHeader(title: 'Recommended for you'),
              FutureBuilder<List<Product>>(
                future: recommendedFuture,
                builder: (c, s) {
                  if (s.connectionState == ConnectionState.waiting)
                    return const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  if (s.hasError || s.data == null || s.data!.isEmpty)
                    return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                      itemCount: s.data!.length,
                      itemBuilder:
                          (ctx, idx) => ProductCard(product: s.data![idx]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
