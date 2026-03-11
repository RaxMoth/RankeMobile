/// Extensions for num types
extension NumExtensions on num {
  /// Convert to duration in milliseconds
  Duration get ms => Duration(milliseconds: toInt());

  /// Convert to duration in seconds
  Duration get seconds => Duration(seconds: toInt());

  /// Convert to duration in minutes
  Duration get minutes => Duration(minutes: toInt());

  /// Convert to duration in hours
  Duration get hours => Duration(hours: toInt());

  /// Convert to duration in days
  Duration get days => Duration(days: toInt());
}

/// Extensions for int
extension IntExtensions on int {
  /// Convert pixels to device pixels
  double toDp() => toDouble();

  /// Check if even
  bool get isEven => this % 2 == 0;

  /// Check if odd
  bool get isOdd => this % 2 != 0;

  /// Check if positive
  bool get isPositive => this > 0;

  /// Check if negative
  bool get isNegative => this < 0;

  /// Check if zero
  bool get isZero => this == 0;
}

/// Extensions for double
extension DoubleExtensions on double {
  /// Round to n decimal places
  double roundTo(int n) {
    final pow = 10 * (n as double);
    return (this * pow).round() / pow;
  }

  /// Check if positive
  bool get isPositive => this > 0;

  /// Check if negative
  bool get isNegative => this < 0;

  /// Check if zero
  bool get isZero => this == 0;

  /// Check if between two numbers
  bool isBetween(double min, double max) => this >= min && this <= max;
}
