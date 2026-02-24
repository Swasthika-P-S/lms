import 'package:flutter/material.dart';

class AppTheme {
  // Professional Terracotta Color Palette
  static const primaryTerracotta = Color(0xFFD4705F); // Mild terracotta
  static const darkTerracotta = Color(0xFFB85840); // Deeper terracotta
  static const lightTerracotta = Color(0xFFE8A598); // Light terracotta
  
  static const darkBackground = Color(0xFF1C1410); // Warm dark brown
  static const darkCard = Color(0xFF2A1F1A); // Dark warm card
  
  static const accentGold = Color(0xFFD4A574); // Warm gold
  static const accentCream = Color(0xFFF5E6D3); // Soft cream
  static const accentBrown = Color(0xFF8B6F47); // Warm brown
  static const accentSage = Color(0xFF9CAF88); // Sage green accent
  
  // Keep for compatibility
  static const primaryPurple = primaryTerracotta;
  static const accentOrange = darkTerracotta;
  static const accentPink = lightTerracotta;
  static const accentCyan = accentSage;
  static const accentGreen = accentSage;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryTerracotta,
    scaffoldBackgroundColor: const Color(0xFFFAF7F5), // Warm off-white
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: primaryTerracotta,
      secondary: accentGold,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF2A1F1A),
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryTerracotta,
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCard,
    colorScheme: const ColorScheme.dark(
      primary: primaryTerracotta,
      secondary: accentGold,
      surface: darkCard,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: accentCream,
      elevation: 0,
    ),
  );
}
