import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette matching your design
  static const primaryPurple = Color(0xFF6366F1);
  static const darkBackground = Color(0xFF0F0A1F);
  static const darkCard = Color(0xFF1A1432);
  static const accentOrange = Color(0xFFFF6B35);
  static const accentPink = Color(0xFFEC4899);
  static const accentCyan = Color(0xFF06B6D4);
  static const accentGreen = Color(0xFF10B981);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: Colors.grey[50],
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: primaryPurple,
      secondary: accentPink,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCard,
    colorScheme: const ColorScheme.dark(
      primary: primaryPurple,
      secondary: accentPink,
      surface: darkCard,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
