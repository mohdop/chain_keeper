import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  AppThemeMode _themeMode = AppThemeMode.dark;

  AppThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeKey);

    if (themeModeString != null) {
      _themeMode = AppThemeMode.values.firstWhere(
        (e) => e.toString() == themeModeString,
        orElse: () => AppThemeMode.dark,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString());
  }

  ThemeMode get materialThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  static const Color _lavender = Color(0xFFD7C6FF); // pastel lavender
  static const Color _offWhite = Color(0xFFFAFAFA); // apple-level offwhite

  // -------------------- DARK THEME (UNCHANGED AESTHETIC) --------------------
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
    primaryColor: const Color(0xFFD7C6FF), // Purple instead of green
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD7C6FF), // Material Purple
      secondary: Color(0xFFD7C6FF), // Light Purple
      tertiary: Color.fromARGB(255, 197, 172, 255), // Deep Purple
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Color(0xFFD7C6FF),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFD7C6FF),
      foregroundColor: Colors.white,
    ),
  );

  }

  // -------------------- NEW LIGHT THEME (PASTEL LAVENDER + OFFWHITE) --------------------
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lavender,
        secondary: _lavender,
        surface: _offWhite,
        background: _offWhite,
        error: Color(0xFFB00020),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.black87,
        onBackground: Colors.black87,
      ),
      scaffoldBackgroundColor: _offWhite,
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: _offWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lavender,
        foregroundColor: Colors.black,
      ),
    );
  }
}
