import 'package:flutter/material.dart';
import '../../../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService _themeService = ThemeService();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  /// Load saved theme from storage
  Future<void> _loadTheme() async {
    _themeMode = await _themeService.getTheme();
    notifyListeners();
  }

  /// Set theme mode and save to storage
  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    _themeService.saveTheme(mode);
    notifyListeners();
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
  }
}
