import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn_dashboard/features/cards/domain/entities/bank_card.dart';

void main() {
  group('BankCard', () {
    const card = BankCard(
      id: 'c1',
      cardHolderName: 'Tayyab Sohail',
      cardNumber: '5399830912343466',
      validDate: '12 / 02 / 2024',
      cvv: '663',
      network: CardNetwork.mastercard,
      isVirtual: false,
      isFrozen: false,
    );

    test('maskedNumber reveals only the last 4 digits', () {
      expect(card.maskedNumber, '•••• •••• •••• 3466');
    });

    test('formattedNumber groups digits into blocks of 4', () {
      expect(card.formattedNumber, '5399 8309 1234 3466');
    });

    test('copyWith toggles isFrozen without mutating the original', () {
      final frozen = card.copyWith(isFrozen: true);

      expect(frozen.isFrozen, isTrue);
      expect(card.isFrozen, isFalse);
      expect(frozen.cardNumber, card.cardNumber);
    });
  });
}
