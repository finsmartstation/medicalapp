import 'package:intl/intl.dart';

class Helpers {
  static String formatTime(String dateTimeString) {
    DateTime parsedTime = DateFormat('HH:mm:ss').parse(dateTimeString);
    String formattedTime = DateFormat('h:mm a').format(parsedTime);
    return formattedTime;
  }

  static double convertIntoDouble(String stringdouble) {
    return double.parse(stringdouble);
  }
}
