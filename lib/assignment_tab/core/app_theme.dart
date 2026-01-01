import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildAppTheme() {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.card,
      foregroundColor: AppColors.textPrimary,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.card,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
      behavior: SnackBarBehavior.floating,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textPrimary,
    ),
  );
}
