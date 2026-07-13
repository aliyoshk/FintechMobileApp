import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../dto/bank_card_dto.dart';

/// Handles raw data access for cards from bundled mock assets.
class CardsLocalDatasource {
  Future<List<BankCardDto>> loadCards() async {
    final raw = await rootBundle.loadString('assets/mock/cards.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return (decoded['cards'] as List)
        .map((e) => BankCardDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

