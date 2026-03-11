import 'package:logger/logger.dart';

/// Centralized Logger Service
class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceMillies,
    ),
  );

  /// Log debug message
  static void debug(String message) {
    _logger.d(message);
  }

  /// Log info message
  static void info(String message) {
    _logger.i(message);
  }

  /// Log warning message
  static void warning(String message) {
    _logger.w(message);
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log verbose message
  static void verbose(String message) {
    _logger.v(message);
  }

  /// Log what the fuck message
  static void wtf(String message) {
    _logger.wtf(message);
  }
}
