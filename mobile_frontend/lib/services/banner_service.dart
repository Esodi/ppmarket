import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/banner.dart';

class BannerService {
  final GraphQLClient client;

  BannerService(this.client);

  Future<List<BannerModel>> fetchBanners() async {
    // Since "banners" doesn't exist in Saleor, let's use categories or create mock data
    // For now, return mock data or use another query
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

    return [
      BannerModel(
        id: '1',
        title: 'Welcome to PP Market',
        imageUrl:
            'https://via.placeholder.com/400x200/FF6B6B/FFFFFF?text=Welcome',
        link: null,
      ),
      BannerModel(
        id: '2',
        title: 'Big Sale Today!',
        imageUrl: 'https://via.placeholder.com/400x200/4ECDC4/FFFFFF?text=Sale',
        link: null,
      ),
    ];
  }
}
