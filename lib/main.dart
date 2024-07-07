

import 'package:flutter/material.dart';
import 'package:flutter_task/product_page.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'login_token.dart';

void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  final token = await loginData().getToken();
  runApp(MyApp(initialRoute: token == null ? '/login' : '/home'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      initialRoute:  initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/addProduct': (context) => const AddProductPage(),
      },
    );
  }
}