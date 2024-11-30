// main.dart
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_page.dart';
import 'screens/home_page.dart'; // Ensure correct import for HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE86343),
        primarySwatch: MaterialColor(0xFFE86343, {
          50: const Color(0xFFFEF2F0),
          100: const Color(0xFFFDE6E2),
          200: const Color(0xFFFBCDC5),
          300: const Color(0xFFF9B3A8),
          400: const Color(0xFFF6998B),
          500: const Color(0xFFE86343),
          600: const Color(0xFFD15B3D),
          700: const Color(0xFFBA5237),
          800: const Color(0xFFA34931),
          900: const Color(0xFF8C402B),
        }),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE86343),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Color(0xFFE86343),
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
