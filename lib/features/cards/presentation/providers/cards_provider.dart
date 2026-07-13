import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bank_card.dart';
import 'cards_repository_provider.dart';

final cardsStreamProvider = StreamProvider.autoDispose<List<BankCard>>((ref) {
  final useCase = ref.watch(watchCardsUseCaseProvider);
  return useCase();
});

/// Exposes just the freeze/unfreeze action via its use case.
final toggleFreezeProvider = Provider<Future<void> Function(String)>((ref) {
  final useCase = ref.watch(toggleFreezeCardUseCaseProvider);
  return useCase.call;
});
