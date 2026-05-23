import 'package:flutter/material.dart';

class AppTheme {
  // Your requested palette (from the image you sent).
  static const Color auroraPrimary = Color(0xFF62079B); // deep purple
  static const Color auroraSecondary = Color(0xFF90E680); // green
  static const Color auroraSky = Color(0xFF67C3C8); // sky/cyan
  static const Color auroraAccent = Color(0xFFFF24CF); // hot pink/magenta
  static const Color auroraLavender = Color(0xFFD9B2FF); // lilac
  static const Color auroraSoftPink = Color(0xFFFAA2D5); // soft pink

  static ThemeData lightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: auroraPrimary,
        primary: auroraPrimary,
        secondary: auroraSky,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FDFA),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        foregroundColor: Colors.white,
        backgroundColor: auroraPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: auroraPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDCEBFF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: auroraSecondary, width: 1.2),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: auroraPrimary,
        primary: auroraPrimary,
        secondary: auroraSky,
        surface: const Color(0xFF0F0A17),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF07060B),
      brightness: Brightness.dark,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        foregroundColor: Colors.white,
        backgroundColor: auroraPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF14101E),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: auroraPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF15111E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A1E3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: auroraSecondary, width: 1.2),
        ),
      ),
    );
  }
}
