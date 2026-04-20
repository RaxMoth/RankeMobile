import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Terminal-inspired text styles with uppercase tracking
abstract class AppTextStyles {
  // Branding / large titles
  static TextStyle get displayLarge => GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
    height: 1.1,
  );

  // Section headers (e.g. "MY ACTIVE BOARDS")
  static TextStyle get sectionHeader => GoogleFonts.spaceGrotesk(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.6,
  );

  // Subtitles (e.g. "TERMINAL READY", "FINANCE • STANDARD METRIC")
  static TextStyle get subtitle => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );

  // Labels (e.g. "RANK 04", "TOP MARK", field labels)
  static TextStyle get label => GoogleFonts.ibmPlexMono(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
    letterSpacing: 0.8,
  );

  // Body text
  static TextStyle get body => GoogleFonts.manrope(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // Body secondary
  static TextStyle get bodySecondary => GoogleFonts.manrope(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.35,
  );

  // Large values (e.g. "245k", "21:45")
  static TextStyle get valueDisplay => GoogleFonts.spaceGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Stat values in standings (e.g. "+48.2%")
  static TextStyle get statValue => GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Unit text (e.g. "USD", "MIN", "KG")
  static TextStyle get unit => GoogleFonts.ibmPlexMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
  );

  // Rank number in standings
  static TextStyle get rankNumber => GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    fontStyle: FontStyle.italic,
  );

  // Button text
  static TextStyle get button => GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.background,
    letterSpacing: 0.4,
  );

  // Tab / filter text
  static TextStyle get tab => GoogleFonts.spaceGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );

  // Badge text (e.g. "FINANCE", "ACTIVE")
  static TextStyle get badge => GoogleFonts.ibmPlexMono(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Board name in directory
  static TextStyle get boardTitle => GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Screen title
  static TextStyle get screenTitle => GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
  );
}
