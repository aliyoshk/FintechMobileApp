import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/environment/app_environment.dart';
import '../../../../core/environment/environment_config.dart';
import '../../../../core/di/dio_provider.dart';
import '../../data/datasource/cards_local_datasource.dart';
import '../../data/repositories/mock_cards_repository_impl.dart';
import '../../data/repositories/remote_cards_repository_impl.dart';
import '../../domain/repositories/cards_repository.dart';
import '../../domain/usecases/toggle_freeze_card_usecase.dart';
import '../../domain/usecases/watch_cards_usecase.dart';

final cardsRepositoryProvider = Provider<CardsRepository>((ref) {
  switch (EnvironmentConfig.current) {
    case AppEnvironment.mock:
      return MockCardsRepositoryImpl(CardsLocalDatasource());
    case AppEnvironment.remote:
      return RemoteCardsRepositoryImpl(ref.watch(dioProvider));
  }
});

final watchCardsUseCaseProvider = Provider<WatchCardsUseCase>((ref) {
  return WatchCardsUseCase(ref.watch(cardsRepositoryProvider));
});

final toggleFreezeCardUseCaseProvider = Provider<ToggleFreezeCardUseCase>((ref) {
  return ToggleFreezeCardUseCase(ref.watch(cardsRepositoryProvider));
});
