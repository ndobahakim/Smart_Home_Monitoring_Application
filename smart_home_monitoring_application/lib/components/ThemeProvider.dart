// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme;
  final String key = "theme";
  SharedPreferences? _prefs;

  ThemeNotifier() : _currentTheme = whiteTheme {
    _loadFromPrefs();
  }

  ThemeData get currentTheme => _currentTheme;

  Future<void> toggleTheme() async {
    _currentTheme = (_currentTheme == whiteTheme) ? blackTheme : whiteTheme;
    await _saveToPrefs(_currentTheme == whiteTheme ? 'white' : 'black');
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    final themeStr = _prefs!.getString(key) ?? 'white';
    _currentTheme = (themeStr == 'black') ? blackTheme : whiteTheme;
    notifyListeners();
  }

  Future<void> _saveToPrefs(String themeStr) async {
    await _initPrefs();
    await _prefs!.setString(key, themeStr);
  }
}

ThemeData whiteTheme = ThemeData(
  primaryColor: Color.fromARGB(255, 130, 123, 123),
  hintColor: Color.fromARGB(255, 0, 0, 0),
  scaffoldBackgroundColor: Color.fromARGB(255, 130, 123, 123),
  // Define other text styles as needed
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.white, // Or any other color
  ),
  // Add other customizations as needed
);

ThemeData blackTheme = ThemeData(
  primaryColor: Colors.black,
  hintColor: Color.fromARGB(255, 255, 255, 255),
  scaffoldBackgroundColor: Colors.black,
  // Define other text styles as needed
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Color.fromARGB(255, 128, 19, 19),
    unselectedItemColor: Colors.white, // Or any other color
  ),
  // Add other customizations as needed
);

