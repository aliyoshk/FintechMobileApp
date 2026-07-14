import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn_dashboard/features/cards/domain/entities/bank_card.dart';
import 'package:mintyn_dashboard/features/cards/domain/repositories/cards_repository.dart';
import 'package:mintyn_dashboard/features/cards/domain/usecases/toggle_freeze_card_usecase.dart';
import 'package:mintyn_dashboard/features/cards/domain/usecases/watch_cards_usecase.dart';

class _FakeCardsRepository implements CardsRepository {
  final List<BankCard> _cards = [
    const BankCard(
      id: 'c1',
      cardHolderName: 'Test',
      cardNumber: '5399830912343466',
      validDate: '12 / 02 / 2024',
      cvv: '663',
      network: CardNetwork.mastercard,
      isVirtual: false,
      isFrozen: false,
    ),
  ];

  @override
  Stream<List<BankCard>> watchCards() => Stream.value(_cards);

  @override
  Future<void> toggleFreeze(String cardId) async {
    final idx = _cards.indexWhere((c) => c.id == cardId);
    if (idx != -1) {
      _cards[idx] = _cards[idx].copyWith(isFrozen: !_cards[idx].isFrozen);
    }
  }
}

void main() {
  late _FakeCardsRepository repository;

  setUp(() => repository = _FakeCardsRepository());

  test('WatchCardsUseCase delegates to repository', () async {
    final useCase = WatchCardsUseCase(repository);
    final cards = await useCase().first;

    expect(cards.length, 1);
    expect(cards.first.cardHolderName, 'Test');
  });

  test('ToggleFreezeCardUseCase flips frozen state via repository', () async {
    final toggleUseCase = ToggleFreezeCardUseCase(repository);

    await toggleUseCase('c1');

    final cards = await repository.watchCards().first;
    expect(cards.first.isFrozen, isTrue);
  });
}

