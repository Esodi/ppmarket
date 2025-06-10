import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLClientProvider {
  static ValueNotifier<GraphQLClient> initializeClient([String? token]) {
    final HttpLink httpLink = HttpLink('http://localhost:8000/graphql/');

    Link link = httpLink;

    if (token != null && token.isNotEmpty) {
      final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
      link = authLink.concat(httpLink);
    }

    return ValueNotifier(
      GraphQLClient(cache: GraphQLCache(store: HiveStore()), link: link),
    );
  }
}
