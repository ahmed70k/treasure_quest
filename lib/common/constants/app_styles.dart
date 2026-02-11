import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFFA500); // Gold
  static const Color secondary = Color(0xFF2C3E50); // Midnight Blue
  static const Color accent = Color(0xFFE74C3C); // Alizarin Crimson
  static const Color background = Color(0xFF121212); // Near Black
  static const Color surface = Color(0xFF1E1E1E); // Dark Grey
  static const Color error = Color(0xFFCF6679);
  static const Color onPrimary = Colors.black;
  static const Color onSecondary = Colors.white;
  static const Color onBackground = Colors.white;
  static const Color onSurface = Colors.white;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
    letterSpacing: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.onBackground,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
}
