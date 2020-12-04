import 'package:intl/intl.dart';

class Utils {
  static String convertDateFromString(
      String dateToConvert, String formatString) {
    DateTime convertedDate = DateTime.parse(dateToConvert);
    var formatter = new DateFormat(formatString);
    return formatter.format(convertedDate);
  }
  static String capitalizeSentence(String string) {
    List<String> phrase = string.split(" ");
    List<String> newPhrase = [];

    String result = "";

    for (final word in phrase) {
      newPhrase.add(word[0].toUpperCase() + word.substring(1).toLowerCase());
    }

    for (int i = 0; i < newPhrase.length; i++) {
      result += newPhrase[i] + " ";
    }

    return result;
  }
}