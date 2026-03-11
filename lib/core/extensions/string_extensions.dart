/// Extensions for String
extension StringExtensions on String {
  /// Check if string is empty or null
  bool get isEmpty => this.isEmpty;

  /// Check if string is not empty
  bool get isNotEmpty => this.isNotEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((e) => e.capitalize).join(' ');
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Check if string is email
  bool get isEmail {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(this);
  }

  /// Check if string is phone number
  bool get isPhoneNumber {
    return length >= 10 && length <= 15 && removeWhitespace.replaceAll('-', '').contains(RegExp(r'^\d+'));
  }

  /// Truncate string
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return substring(0, maxLength) + '...';
  }

  /// Reverse string
  String get reverse => split('').reversed.join('');

  /// Check if string is numeric
  bool get isNumeric => double.tryParse(this) != null;

  /// Convert string to int
  int? toInt() => int.tryParse(this);

  /// Convert string to double
  double? toDouble() => double.tryParse(this);

  /// Check if string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string contains only alphanumeric characters
  bool get isAlphaNumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
}
