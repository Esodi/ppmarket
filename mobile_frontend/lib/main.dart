import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'config/graphql_client_provider.dart';
import 'services/banner_service.dart';
import 'services/cart_service.dart';
import 'services/category_service.dart';
import 'services/product_service.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final client = GraphQLClientProvider.initializeClient();

    return GraphQLProvider(
      client: client,
      child: MultiProvider(
        providers: [
          Provider<GraphQLClient>(create: (_) => client.value),
          ProxyProvider<GraphQLClient, BannerService>(
            update: (context, client, _) => BannerService(client),
          ),
          ProxyProvider<GraphQLClient, CategoryService>(
            update: (context, client, _) => CategoryService(client),
          ),
          ProxyProvider<GraphQLClient, ProductService>(
            update: (context, client, _) => ProductService(client),
          ),
          ChangeNotifierProvider(create: (_) => CartService()),
        ],
        child: MaterialApp(
          title: 'PP Market',
          debugShowCheckedModeBanner: false, // Add this line
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const HomeScreen(),
          routes: {
            '/search':
                (context) =>
                    const Scaffold(body: Center(child: Text('Search Screen'))),
            '/cart':
                (context) =>
                    const Scaffold(body: Center(child: Text('Cart Screen'))),
          },
        ),
      ),
    );
  }
}
