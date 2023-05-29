import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, {int decimals = 0} ) {

    final formatterNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en',
    ).format(number);

    return formatterNumber;
  }

  static String date(DateTime number) {
    final formatterDate = DateFormat('d/M/y','en_US').format(number);

    return formatterDate;
  }
}
