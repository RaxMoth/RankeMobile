/// Centralized animation durations + curves so every motion in the app
/// shares the same rhythm. Keep this tiny — if you need to add a new
/// duration, first check whether an existing one fits.
library;

import 'package:flutter/animation.dart';

abstract class AppAnimations {
  /// Snappy UI reactions — chip selection, tap acknowledgements.
  static const Duration short = Duration(milliseconds: 180);

  /// Standard screen/step transitions — page changes, sheet pushes.
  static const Duration standard = Duration(milliseconds: 240);

  /// Slower reveals — success states, rank animations.
  static const Duration slow = Duration(milliseconds: 360);

  /// Default ease used across the app.
  static const Curve curve = Curves.easeOutCubic;
}
