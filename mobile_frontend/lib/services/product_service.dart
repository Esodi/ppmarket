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
      print(result.exception.toString());
      return [];
    }

    final List<Product> products =
        (result.data?['products']['edges'] as List)
            .map((e) => Product.fromJson(e['node']))
            .toList();

    return products;
  }
}
