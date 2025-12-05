import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_tracker/features/auth/screens/splash_screen.dart';
import 'package:habit_tracker/core/constants/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bdgefkojubnsagyfdzgs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJkZ2Vma29qdWJuc2FneWZkemdzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4OTIwMTgsImV4cCI6MjA4MDQ2ODAxOH0.gbqNCJPUcyFPcr-nRczyTmhprUATW-9hjkLhMOW3Ey8',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.base,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.lavender,
          secondary: AppColors.mauve,
          background: AppColors.base,
          surface: AppColors.surface0,
          onPrimary: AppColors.base,
          onSecondary: AppColors.base,
          onBackground: AppColors.text,
          onSurface: AppColors.text,
          error: AppColors.red,
          onError: AppColors.base,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.text),
          bodyMedium: TextStyle(color: AppColors.subtext1),
          titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: AppColors.text),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.crust,
          foregroundColor: AppColors.text,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface0,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.lavender,
          foregroundColor: AppColors.base,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
