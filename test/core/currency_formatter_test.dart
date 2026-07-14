import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn_dashboard/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formatBalance produces Figma-style "1200\$" output', () {
      expect(CurrencyFormatter.formatBalance(1200), '1,200\$');
    });

    test('formatAmount produces plain number without currency symbol', () {
      expect(CurrencyFormatter.formatAmount(100), '100');
      expect(CurrencyFormatter.formatAmount(-300), '300');
    });

    test('format produces chart-tooltip style "\$3,657"', () {
      expect(CurrencyFormatter.format(3657), '\$3,657');
    });
  });
}

