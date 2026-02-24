import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Service to persist theme preferences
class ThemeService {
  static const String _themeKey = 'theme_mode';
  
  /// Save theme mode to local storage
  Future<void> saveTheme(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.toString());
      print('✅ Theme saved: $mode');
    } catch (e) {
      print('❌ Error saving theme: $e');
    }
  }
  
  /// Load theme mode from local storage
  Future<ThemeMode> getTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);
      
      if (themeString == null) {
        return ThemeMode.system;
      }
      
      switch (themeString) {
        case 'ThemeMode.light':
          return ThemeMode.light;
        case 'ThemeMode.dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    } catch (e) {
      print('❌ Error loading theme: $e');
      return ThemeMode.system;
    }
  }
}
