import 'package:flutter/material.dart';

class AppTheme {
  // Vibrant "Normal" Color Palette
  static const primaryPurple = Color(0xFF6C63FF); // Vibrant indigo/purple
  static const accentOrange = Color(0xFFFF6B6B); // Vibrant red/orange
  static const accentPink = Color(0xFFFF6BB5); // Vibrant pink
  static const accentCyan = Color(0xFF48CAE4); // Vibrant cyan
  static const accentGreen = Color(0xFF4CAF50); // Vibrant green
  
  // Professional Terracotta (kept for existing references if any, but muted)
  static const primaryTerracotta = Color(0xFFD4705F);
  static const darkTerracotta = Color(0xFFB85840);
  
  static const darkBackground = Color(0xFF0A0E27); // Deep navy background
  static const darkCard = Color(0xFF1A1F3A); // Dark navy card
  
  static const accentGold = Color(0xFFD4A574);
  static const accentCream = Color(0xFFF5E6D3);
  static const accentBrown = Color(0xFF8B6F47);
  static const accentSage = Color(0xFF9CAF88);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Modern slate 50
    cardColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: primaryPurple,
      secondary: const Color(0xFF0EA5E9), // Sky 500
      surface: Colors.white,
      onSurface: const Color(0xFF1E293B), // Slate 800
      primaryContainer: primaryPurple.withOpacity(0.1),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1E293B),
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Color(0xFF334155)),
      bodyMedium: TextStyle(color: Color(0xFF64748B)),
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
      secondary: accentCyan,
      surface: darkCard,
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
