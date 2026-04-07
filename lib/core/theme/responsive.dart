import 'package:flutter/widgets.dart';

/// Lightweight responsive scaling utility.
///
/// Scales values proportionally from a 375pt baseline (iPhone SE width).
/// Clamped to ±15% so layouts stay visually consistent across SE → Pro Max.
abstract class Responsive {
  static const double _baseWidth = 375.0;

  /// Scale [base] proportionally to the current screen width.
  static double scale(BuildContext context, double base) {
    final width = MediaQuery.sizeOf(context).width;
    return base * (width / _baseWidth).clamp(0.85, 1.15);
  }
}
