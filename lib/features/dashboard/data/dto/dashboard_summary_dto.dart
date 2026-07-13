import 'transaction_dto.dart';

/// JSON-aware DTO mirroring the backend contract for the dashboard payload.
class DashboardSummaryDto {
  final String accountHolderName;
  final String designation;
  final String email;
  final String? profileImageBase64;
  final double availableBalance;
  final String currency;
  final List<QuickActionDto> quickActions;
  final List<TransactionDto> transactions;

  const DashboardSummaryDto({
    required this.accountHolderName,
    required this.designation,
    required this.email,
    this.profileImageBase64,
    required this.availableBalance,
    required this.currency,
    required this.quickActions,
    required this.transactions,
  });

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryDto(
      accountHolderName: json['accountHolderName']?.toString() ?? 'User',
      designation: json['designation']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profileImageBase64: json['profileImageBase64']?.toString(),
      availableBalance: (json['availableBalance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'USD',
      quickActions: (json['quickActions'] as List?)
              ?.map((e) => QuickActionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      transactions: (json['transactions'] as List?)
              ?.map((e) => TransactionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class QuickActionDto {
  final String id;
  final String label;
  final String icon;

  const QuickActionDto({required this.id, required this.label, required this.icon});

  factory QuickActionDto.fromJson(Map<String, dynamic> json) => QuickActionDto(
        id: json['id']?.toString() ?? '',
        label: json['label']?.toString() ?? '',
        icon: json['icon']?.toString() ?? '',
      );
}
