import '../../domain/entities/bank_card.dart';
import '../dto/bank_card_dto.dart';

/// Converts [BankCardDto] → domain [BankCard] entity.
class CardMapper {
  const CardMapper._();

  static BankCard fromDto(BankCardDto dto) {
    return BankCard(
      id: dto.id,
      cardHolderName: dto.cardHolderName,
      cardNumber: dto.cardNumber,
      validDate: dto.validDate,
      cvv: dto.cvv,
      network: _parseNetwork(dto.cardType),
      isVirtual: dto.isVirtual,
      isFrozen: dto.isFrozen,
    );
  }

  static CardNetwork _parseNetwork(String raw) {
    return CardNetwork.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => CardNetwork.mastercard,
    );
  }
}

