import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeNotifier() {
    _loadThemePreference(); // Load saved theme on initialization
  }

  void toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isOn);
  }

  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}
