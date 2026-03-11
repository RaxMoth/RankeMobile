import 'package:intl/intl.dart';

/// Date and time utilities
class DateTimeUtils {
  /// Format date with custom format
  static String formatDate(DateTime dateTime, [String format = 'dd/MM/yyyy']) {
    return DateFormat(format).format(dateTime);
  }

  /// Format time
  static String formatTime(DateTime dateTime, [String format = 'HH:mm']) {
    return DateFormat(format).format(dateTime);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime, [String format = 'dd/MM/yyyy HH:mm']) {
    return DateFormat(format).format(dateTime);
  }

  /// Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  /// Parse date string
  static DateTime? parseDate(String dateString, [String format = 'dd/MM/yyyy']) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Check if date is today
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  /// Get date without time
  static DateTime getDateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Add days to date
  static DateTime addDays(DateTime dateTime, int days) {
    return dateTime.add(Duration(days: days));
  }

  /// Add months to date
  static DateTime addMonths(DateTime dateTime, int months) {
    return DateTime(dateTime.year, dateTime.month + months, dateTime.day);
  }

  /// Add years to date
  static DateTime addYears(DateTime dateTime, int years) {
    return DateTime(dateTime.year + years, dateTime.month, dateTime.day);
  }
}
