import 'package:flutter/material.dart';

class AppColors {
  // Dark theme colors
  static const Color background = Color(0xFF0A0E27);
  static const Color card = Color(0xFF1A1F3A);
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color textPrimary = Colors.white;
  static final Color textSecondary = Colors.white.withOpacity(0.6);
  
  // Light theme colors
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightCard = Colors.white;
  static const Color lightTextPrimary = Color(0xFF1E293B); // Slate 800
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  
  // Helper methods to get theme-aware colors
  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? background 
        : lightBackground;
  }
  
  static Color getCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? card 
        : lightCard;
  }
  
  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? textPrimary 
        : lightTextPrimary;
  }
  
  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? textSecondary 
        : lightTextSecondary;
  }
}