import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'EventMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE86343),
        primarySwatch: MaterialColor(0xFFE86343, {
          50: Color(0xFFFEF2F0),
          100: Color(0xFFFDE6E2),
          200: Color(0xFFFBCDC5),
          300: Color(0xFFF9B3A8),
          400: Color(0xFFF6998B),
          500: Color(0xFFE86343),
          600: Color(0xFFD15B3D),
          700: Color(0xFFBA5237),
          800: Color(0xFFA34931),
          900: Color(0xFF8C402B),
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
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
