/// JSON-aware DTO for bank cards from the API/mock layer.
class BankCardDto {
  final String id;
  final String cardHolderName;
  final String cardNumber;
  final String validDate;
  final String cvv;
  final String cardType;
  final bool isVirtual;
  final bool isFrozen;

  const BankCardDto({
    required this.id,
    required this.cardHolderName,
    required this.cardNumber,
    required this.validDate,
    required this.cvv,
    required this.cardType,
    required this.isVirtual,
    required this.isFrozen,
  });

  factory BankCardDto.fromJson(Map<String, dynamic> json) {
    return BankCardDto(
      id: json['id'] as String,
      cardHolderName: json['cardHolderName'] as String,
      cardNumber: json['cardNumber'] as String,
      validDate: json['validDate'] as String,
      cvv: json['cvv'] as String,
      cardType: json['cardType'] as String,
      isVirtual: json['isVirtual'] as bool,
      isFrozen: json['isFrozen'] as bool,
    );
  }
}

