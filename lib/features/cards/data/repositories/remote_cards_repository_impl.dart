import 'package:dio/dio.dart';
import '../../domain/entities/bank_card.dart';
import '../../domain/repositories/cards_repository.dart';

/// Production stub — same pattern as RemoteDashboardRepositoryImpl.
class RemoteCardsRepositoryImpl implements CardsRepository {
  // ignore: unused_field
  final Dio _dio;

  RemoteCardsRepositoryImpl(this._dio);

  @override
  Stream<List<BankCard>> watchCards() {
    throw UnimplementedError('RemoteCardsRepositoryImpl is a stub.');
  }

  @override
  Future<void> toggleFreeze(String cardId) {
    throw UnimplementedError('RemoteCardsRepositoryImpl is a stub.');
  }
}

