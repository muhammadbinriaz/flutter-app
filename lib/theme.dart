import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFFFFFFF);
  static const sidebar = Color(0xFFF7F6F3);
  static const sidebarHover = Color(0xFFEFEDE9);
  static const sidebarActive = Color(0xFFE8E7E4);
  static const border = Color(0xFFE3E2DE);
  static const text = Color(0xFF37352F);
  static const textMuted = Color(0xFF787774);
  static const textFaint = Color(0xFF9B9A97);
  static const accent = Color(0xFF2383E2);
  static const danger = Color(0xFFEB5757);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        surface: AppColors.bg,
        onSurface: AppColors.text,
      ),
      fontFamily: 'Segoe UI',
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: AppColors.text,
          fontSize: 16,
          height: 1.5,
        ),
      ),
      dividerColor: AppColors.border,
      iconTheme: const IconThemeData(color: AppColors.textMuted, size: 18),
    );
  }
}
