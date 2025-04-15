import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // Подключаем Firebase конфигурацию

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Это нужно для инициализации Firebase перед запуском приложения
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);  // Инициализируем Firebase
  runApp(const MyApp());  // Запускаем приложение после инициализации Firebase
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini E-commerce',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFE0FF),
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF512DA8),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/catalog': (context) => const CatalogScreen(),
        '/cart': (context) => const CartScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/register': (context) => const RegisterScreen(), // Регистрируем роут для регистрации
      },
    );
  }
}
