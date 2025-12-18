import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_tracker/features/auth/screens/splash_screen.dart';
import 'package:habit_tracker/core/constants/app_colors.dart';
import 'dart:async'; // ADD THIS IMPORT

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log Flutter errors to console for development
    FlutterError.presentError(details);
    // You might want to send these to a crash reporting service in production
    // e.g., Crashlytics.recordFlutterError(details);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Упс! Что-то пошло не так.',
              style: TextStyle(color: AppColors.text, fontSize: 18),
            ),
            Text(
              'Пожалуйста, перезапустите приложение.',
              style: TextStyle(color: AppColors.subtext0, fontSize: 14),
            ),
            // For debugging, you can display details:
            // Text(details.exception.toString(), style: TextStyle(color: AppColors.subtext1)),
          ],
        ),
      ),
    );
  };

  runZonedGuarded(() async {
    await Supabase.initialize(
      url: 'https://bdgefkojubnsagyfdzgs.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJkZ2Vma29qdWJuc2FneWZkemdzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4OTIwMTgsImV4cCI6MjA4MDQ2ODAxOH0.gbqNCJPUcyFPcr-nRczyTmhprUATW-9hjkLhMOW3Ey8',
    );
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    // Catch errors outside of the Flutter framework (e.g., from async operations)
    print('Caught an error in runZonedGuarded: $error\n$stack');
    // You might want to send these to a crash reporting service
    // e.g., FirebaseCrashlytics.recordError(error, stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.base,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.lavender,
          secondary: AppColors.mauve,
          surface: AppColors.surface0,
          onPrimary: AppColors.base,
          onSecondary: AppColors.base,
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
