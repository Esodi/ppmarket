import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'config/graphql_client_provider.dart';
import 'routes/app_routes.dart';
import 'providers/app_state_provider.dart';
import 'services/auth_service.dart';
import 'services/product_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/confirm_account_screen.dart';

void main() async {
  await initHiveForFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final clientNotifier = GraphQLClientProvider.initializeClient('');

    return ValueListenableBuilder<GraphQLClient>(
      valueListenable: clientNotifier,
      builder: (context, client, _) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppStateProvider()),
            Provider<AuthService>(create: (_) => AuthService(client)),
            Provider<ProductService>(create: (_) => ProductService(client)),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Saleor App',
            theme: ThemeData(primarySwatch: Colors.blue),
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (_) => SplashScreen(),
              AppRoutes.login: (_) => LoginScreen(),
              AppRoutes.register: (context) => RegisterScreen(),
              AppRoutes.confirmAccount: (context) => ConfirmAccountScreen(),
              AppRoutes.home: (_) => HomeScreen(),
              AppRoutes.cart: (_) => CartScreen(),
              AppRoutes.checkout: (_) => CheckoutScreen(),
            },
          ),
        );
      },
    );
  }
}
