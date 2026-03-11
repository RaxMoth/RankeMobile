import 'package:flutter/material.dart';

/// Extensions for BuildContext
extension ContextExtensions on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Check if device is in landscape
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if device is in portrait
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  /// Get padding
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Get viewInsets
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Check if device is mobile
  bool get isMobile => screenWidth < 600;

  /// Check if device is tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Check if device is desktop
  bool get isDesktop => screenWidth >= 1200;

  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get is dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Show snackbar
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: duration,
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
      ),
    );
  }

  /// Pop to previous screen
  void pop<T extends Object>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Push route
  Future<T?> push<T extends Object>(Route<T> route) {
    return Navigator.of(this).push(route);
  }

  /// Replace route
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed(routeName, result: result, arguments: arguments);
  }
}
