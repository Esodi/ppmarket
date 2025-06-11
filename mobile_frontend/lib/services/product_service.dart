import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/product.dart';

class ProductService {
  final GraphQLClient client;

  ProductService(this.client);

  Future<List<Product>> fetchProducts() async {
    final QueryOptions options = QueryOptions(
      document: gql('''
        query GetProducts {
          products(first: 20) {
            edges {
              node {
                id
                name
                description
                thumbnail {
                  url
                }
                pricing {
                  priceRange {
                    start {
                      gross {
                        amount
                        currency
                      }
                    }
                  }
                }
              }
            }
          }
        }
      '''),
    );

    final result = await client.query(options);
    if (result.hasException) {
      print('Products error: ${result.exception.toString()}');
      return [];
    }

    final List<Product> products =
        (result.data?['products']['edges'] as List? ?? [])
            .map((e) => Product.fromJson(e['node']))
            .toList();

    return products;
  }

  Future<List<Product>> fetchOnSaleProducts({int? limit}) async {
    // Since isOnSale filter doesn't exist, let's just fetch regular products
    final QueryOptions options = QueryOptions(
      document: gql('''
        query GetProducts(\$first: Int) {
          products(first: \$first) {
            edges {
              node {
                id
                name
                description
                thumbnail {
                  url
                }
                pricing {
                  priceRange {
                    start {
                      gross {
                        amount
                        currency
                      }
                    }
                  }
                }
              }
            }
          }
        }
      '''),
      variables: {'first': limit ?? 6},
    );

    final result = await client.query(options);
    if (result.hasException) {
      print('On sale products error: ${result.exception.toString()}');
      return [];
    }

    final List<Product> products =
        (result.data?['products']['edges'] as List? ?? [])
            .map((e) => Product.fromJson(e['node']))
            .toList();

    return products;
  }

  Future<List<Product>> fetchRecommendedProducts({int? limit}) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
        query GetRecommendedProducts(\$first: Int) {
          products(first: \$first, sortBy: {field: NAME, direction: ASC}) {
            edges {
              node {
                id
                name
                description
                thumbnail {
                  url
                }
                pricing {
                  priceRange {
                    start {
                      gross {
                        amount
                        currency
                      }
                    }
                  }
                }
              }
            }
          }
        }
      '''),
      variables: {'first': limit ?? 6},
    );

    final result = await client.query(options);
    if (result.hasException) {
      print('Recommended products error: ${result.exception.toString()}');
      return [];
    }

    final List<Product> products =
        (result.data?['products']['edges'] as List? ?? [])
            .map((e) => Product.fromJson(e['node']))
            .toList();

    return products;
  }
}
