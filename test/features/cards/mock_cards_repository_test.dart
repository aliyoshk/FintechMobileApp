import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn_dashboard/features/cards/data/datasource/cards_local_datasource.dart';
import 'package:mintyn_dashboard/features/cards/data/repositories/mock_cards_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('toggleFreeze flips isFrozen and emits the updated list', () async {
    final repository = MockCardsRepositoryImpl(CardsLocalDatasource());

    // Collect the first two emissions: initial snapshot + post-toggle update.
    final emissions = <dynamic>[];
    final completer = Completer<void>();
    final sub = repository.watchCards().listen((cards) {
      emissions.add(cards);
      if (emissions.length == 2) completer.complete();
    });

    // Wait for the initial emission.
    await Future<void>.delayed(Duration.zero);
    expect(emissions.length, 1);

    final targetId = emissions.first.first.id;
    final wasFrozen = emissions.first.first.isFrozen;

    await repository.toggleFreeze(targetId);
    await completer.future;

    expect(emissions[1].first.isFrozen, !wasFrozen);
    await sub.cancel();
  });
}
