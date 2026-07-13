import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _plain = NumberFormat('#,##0', 'en_US');

  /// Formats balance values as shown in the Figma design: "1200$".
  static String formatBalance(double amount) =>
      '${_plain.format(amount.truncate())}\$';

  /// Formats transaction amounts without currency symbol: "100".
  static String formatAmount(double amount) =>
      _plain.format(amount.abs().truncate()).toString();

  /// Legacy helper – kept for the spending-chart tooltip which uses "$3,657".
  static String format(double amount) => '\$${_plain.format(amount.truncate())}';
}
