import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/quick_action.dart';
import '../../domain/entities/transaction.dart';
import '../dto/dashboard_summary_dto.dart';
import '../dto/transaction_dto.dart';

/// Converts data-layer DTOs into domain entities.
/// If the backend schema changes, only the DTO and this mapper are touched —
/// domain entities and UI remain untouched.
class DashboardMapper {
  const DashboardMapper._();

  static DashboardSummary fromDto(DashboardSummaryDto dto) {
    return DashboardSummary(
      accountHolderName: dto.accountHolderName,
      designation: dto.designation,
      email: dto.email,
      profileImageBase64: dto.profileImageBase64,
      availableBalance: dto.availableBalance,
      currency: dto.currency,
      quickActions: dto.quickActions.map(_mapQuickAction).toList(),
      transactions: dto.transactions.map(fromTransactionDto).toList(),
    );
  }

  static QuickAction _mapQuickAction(QuickActionDto dto) {
    return QuickAction(id: dto.id, label: dto.label, icon: dto.icon);
  }

  static Transaction fromTransactionDto(TransactionDto dto) {
    return Transaction(
      id: dto.id,
      title: dto.title,
      category: dto.category,
      amount: dto.amount,
      timestamp: dto.timestamp,
    );
  }
}
