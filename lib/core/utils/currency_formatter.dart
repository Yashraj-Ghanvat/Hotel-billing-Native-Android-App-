import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, {String symbol = '₹', int decimalDigits = 2}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, {String symbol = '₹'}) {
    return '$symbol${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }
}
