import 'package:intl/intl.dart';

class Helpers {
  static String formatTime(String dateTimeString) {
    DateTime parsedTime = DateFormat('HH:mm:ss').parse(dateTimeString);
    int currentYear = DateTime.now().year;
    String formattedTime = DateFormat('h:mm a').format(parsedTime);
    //String formattedDateTime = '$formattedTime, $currentYear';
    return formattedTime;
  }
}
