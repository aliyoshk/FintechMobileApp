import 'dart:async';
import '../../domain/entities/bank_card.dart';
import '../../domain/repositories/cards_repository.dart';
import '../datasource/cards_local_datasource.dart';
import '../mapper/card_mapper.dart';

/// Mock implementation — loads seed data from the local datasource,
/// maps DTOs to domain entities, and streams updates via a broadcast
/// controller so freeze/unfreeze is reflected immediately.
class MockCardsRepositoryImpl implements CardsRepository {
  final CardsLocalDatasource _datasource;
  final _controller = StreamController<List<BankCard>>.broadcast();
  List<BankCard>? _cards;

  MockCardsRepositoryImpl(this._datasource);

  @override
  Stream<List<BankCard>> watchCards() async* {
    if (_cards == null) {
      final dtos = await _datasource.loadCards();
      _cards = dtos.map(CardMapper.fromDto).toList();
    }
    yield _cards!;
    yield* _controller.stream;
  }

  @override
  Future<void> toggleFreeze(String cardId) async {
    if (_cards == null) return;
    _cards = _cards!
        .map((c) => c.id == cardId ? c.copyWith(isFrozen: !c.isFrozen) : c)
        .toList();
    _controller.add(_cards!);
  }
}

