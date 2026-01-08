import 'package:intl/intl.dart';

class TCurrencyFormatter {
  static String formatVND(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }
}