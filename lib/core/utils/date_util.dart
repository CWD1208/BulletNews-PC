import 'package:intl/intl.dart';

class DateUtil {
  static const String defaultFormat = 'yyyy-MM-dd HH:mm:ss';

  /// Format DateTime to String
  static String formatDate(DateTime? date, {String format = defaultFormat}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  /// Format milliseconds to String
  static String formatMillis(
    int milliseconds, {
    String format = defaultFormat,
  }) {
    return formatDate(
      DateTime.fromMillisecondsSinceEpoch(milliseconds),
      format: format,
    );
  }

  /// Parse String to DateTime
  static DateTime? parse(String dateStr, {String format = defaultFormat}) {
    if (dateStr.isEmpty) return null;
    try {
      return DateFormat(format).parse(dateStr);
    } catch (e) {
      return null;
    }
  }
}
