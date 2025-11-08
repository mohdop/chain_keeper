import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // -------------------- COULEURS DU LOGO --------------------
  // Violet du logo
  static const Color _primaryViolet = Color(0xFF8B5CF6);
  // Rose/Magenta du logo
  static const Color _secondaryPink = Color(0xFFEC4899);
  // Bleu du logo
  static const Color _tertiaryBlue = Color(0xFF2563EB);
  // Fond ultra sombre
  static const Color _darkBackground = Color(0xFF0F0F1E);
  static const Color _darkSurface = Color(0xFF1A1A2E);
  static const Color _darkCard = Color(0xFF1E2235);
  
  // Pour le light mode
  static const Color _lightViolet = Color(0xFFA78BFA); // Violet plus clair
  static const Color _offWhite = Color(0xFFFAFAFA);

  // -------------------- DARK THEME (NOUVEAU AVEC COULEURS DU LOGO) --------------------
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: _primaryViolet,
      scaffoldBackgroundColor: _darkBackground,
      
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ),
      
      colorScheme: const ColorScheme.dark(
        primary: _primaryViolet, // Violet principal
        secondary: _secondaryPink, // Rose
        tertiary: _tertiaryBlue, // Bleu
        surface: _darkSurface,
        background: _darkBackground,
        error: Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryViolet,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryViolet, width: 2),
        ),
      ),
      
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryViolet,
      ),
      
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.1),
        thickness: 1,
      ),
    );
  }

  // -------------------- LIGHT THEME (AVEC COULEURS DU LOGO ADAPTÉES) --------------------
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _lightViolet,
      scaffoldBackgroundColor: _offWhite,
      
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme,
      ),
      
      colorScheme: ColorScheme.light(
        primary: _lightViolet,
        secondary: _secondaryPink.withOpacity(0.7),
        tertiary: _tertiaryBlue.withOpacity(0.7),
        surface: Colors.white,
        background: _offWhite,
        error: const Color(0xFFB00020),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onBackground: Colors.black87,
      ),
      
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: _lightViolet.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: _offWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.black87,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _lightViolet,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightViolet,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _lightViolet, width: 2),
        ),
      ),
      
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: _lightViolet,
      ),
      
      dividerTheme: DividerThemeData(
        color: Colors.black.withOpacity(0.1),
        thickness: 1,
      ),
    );
  }
}