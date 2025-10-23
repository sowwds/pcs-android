import 'package:flutter/material.dart';
import 'screens/create_account_screen.dart';
import 'theme/colors.dart';

void main() {
  runApp(const MadShopApp());
}

class MadShopApp extends StatelessWidget {
  const MadShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAD Shopp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 50, fontFamily: 'Raleway', color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Poppins', color: Colors.black),
          titleMedium: TextStyle(fontSize: 22, fontFamily: 'Nunito Sans', color: Colors.black),
        ),
      ),
      home: CreateAccountScreen(),
    );
  }
}
