import 'package:flutter/material.dart';

/// Ranked dark terminal color palette
abstract class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceLight = Color(0xFF1E1E1E);
  static const Color card = Color(0xFF1A1A1A);

  // Accent — amber/gold
  static const Color accent = Color(0xFFD4A017);
  static const Color accentLight = Color(0xFFE8C547);
  static const Color accentDim = Color(0xFF8B6914);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF999999);
  static const Color textTertiary = Color(0xFF666666);
  static const Color textMuted = Color(0xFF444444);

  // Borders
  static const Color border = Color(0xFF2A2A2A);
  static const Color borderLight = Color(0xFF333333);

  // Functional
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);

  // Category colors (for left border accents on directory items)
  static const Color categoryFinance = Color(0xFFD4A017);
  static const Color categoryFitness = Color(0xFFE53935);
  static const Color categoryCoding = Color(0xFF42A5F5);
  static const Color categoryHealth = Color(0xFF66BB6A);

  // Value type colors
  static const Color categoryDuration = Color(0xFFFF9800);

  static const Color transparent = Colors.transparent;
}
