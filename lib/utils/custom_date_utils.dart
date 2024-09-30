import 'package:intl/intl.dart';

class CustomDateUtils {
  static String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }
}
