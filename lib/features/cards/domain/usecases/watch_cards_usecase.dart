import '../entities/bank_card.dart';
import '../repositories/cards_repository.dart';

/// Watches the live card list from any repository implementation.
class WatchCardsUseCase {
  final CardsRepository _repository;

  const WatchCardsUseCase(this._repository);

  Stream<List<BankCard>> call() => _repository.watchCards();
}

