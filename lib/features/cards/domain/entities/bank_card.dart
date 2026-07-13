enum CardNetwork { mastercard, visa, verve }

/// Pure domain entity representing a bank card.
/// Domain logic like [maskedNumber] and [formattedNumber] lives here
/// because card-number masking is a real business rule, not a display concern.
class BankCard {
  final String id;
  final String cardHolderName;
  final String cardNumber;
  final String validDate;
  final String cvv;
  final CardNetwork network;
  final bool isVirtual;
  final bool isFrozen;

  const BankCard({
    required this.id,
    required this.cardHolderName,
    required this.cardNumber,
    required this.validDate,
    required this.cvv,
    required this.network,
    required this.isVirtual,
    required this.isFrozen,
  });

  String get maskedNumber {
    final last4 = cardNumber.substring(cardNumber.length - 4);
    return '•••• •••• •••• $last4';
  }

  String get formattedNumber {
    final buffer = StringBuffer();
    for (int i = 0; i < cardNumber.length; i += 4) {
      if (i > 0) buffer.write(' ');
      buffer.write(cardNumber.substring(i, (i + 4).clamp(0, cardNumber.length)));
    }
    return buffer.toString();
  }

  BankCard copyWith({bool? isFrozen}) {
    return BankCard(
      id: id,
      cardHolderName: cardHolderName,
      cardNumber: cardNumber,
      validDate: validDate,
      cvv: cvv,
      network: network,
      isVirtual: isVirtual,
      isFrozen: isFrozen ?? this.isFrozen,
    );
  }
}

