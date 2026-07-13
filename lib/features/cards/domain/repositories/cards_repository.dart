import '../entities/bank_card.dart';

/// Contract for the cards feature. Lives in domain so presentation
/// never depends on a concrete data-layer class.
abstract class CardsRepository {
  Stream<List<BankCard>> watchCards();
  Future<void> toggleFreeze(String cardId);
}

