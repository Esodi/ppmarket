import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/category.dart';

class CategoryService {
  final GraphQLClient client;

  CategoryService(this.client);

  Future<List<Category>> fetchCategories() async {
    final QueryOptions options = QueryOptions(
      document: gql('''
        query GetCategories {
          categories(first: 20) {
            edges {
              node {
                id
                name
                slug
                backgroundImage {
                  url
                }
              }
            }
          }
        }
      '''),
    );

    final result = await client.query(options);
    if (result.hasException) {
      print('Categories error: ${result.exception.toString()}');
      return [];
    }

    final List<Category> categories =
        (result.data?['categories']['edges'] as List? ?? [])
            .map((e) => Category.fromJson(e['node']))
            .toList();

    return categories;
  }
}
