import 'package:intl/intl.dart';

class DateUtil {
  // Format: 2023-10-25
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format: October 25, 2023
  static String formatReadable(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  // Format: October 25, 2023 • 10:23 AM
  static String formatDateTime(DateTime date) {
    return DateFormat('MMMM dd, yyyy • h:mm a').format(date);
  }

  // Returns true if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Strip time from DateTime (set to 00:00:00)
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
