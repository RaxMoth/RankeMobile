import 'package:flutter/material.dart';

import 'colors.dart';

/// Terminal-inspired text styles with uppercase tracking
abstract class AppTextStyles {
  // Branding / large titles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
  );

  // Section headers (e.g. "MY ACTIVE BOARDS")
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 2.0,
  );

  // Subtitles (e.g. "TERMINAL READY", "FINANCE • STANDARD METRIC")
  static const TextStyle subtitle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
  );

  // Labels (e.g. "RANK 04", "TOP MARK", field labels)
  static const TextStyle label = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
    letterSpacing: 1.5,
  );

  // Body text
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // Body secondary
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Large values (e.g. "245k", "21:45")
  static const TextStyle valueDisplay = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  // Stat values in standings (e.g. "+48.2%")
  static const TextStyle statValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  // Unit text (e.g. "USD", "MIN", "KG")
  static const TextStyle unit = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 1.0,
  );

  // Rank number in standings
  static const TextStyle rankNumber = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppColors.textMuted,
    fontStyle: FontStyle.italic,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: AppColors.background,
    letterSpacing: 2.0,
  );

  // Tab / filter text
  static const TextStyle tab = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  // Badge text (e.g. "FINANCE", "ACTIVE")
  static const TextStyle badge = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  // Board name in directory
  static const TextStyle boardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  // Screen title
  static const TextStyle screenTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
}
