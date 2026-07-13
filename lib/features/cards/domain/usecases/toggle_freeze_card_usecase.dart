import '../repositories/cards_repository.dart';

/// Toggles the frozen state of a specific card.
class ToggleFreezeCardUseCase {
  final CardsRepository _repository;

  const ToggleFreezeCardUseCase(this._repository);

  Future<void> call(String cardId) => _repository.toggleFreeze(cardId);
}

