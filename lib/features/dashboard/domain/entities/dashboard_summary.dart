import 'quick_action.dart';
import 'transaction.dart';

class DashboardSummary {
  final String accountHolderName;
  final String designation;
  final String email;
  final String? profileImageBase64;
  final double availableBalance;
  final String currency;
  final List<QuickAction> quickActions;
  final List<Transaction> transactions;

  const DashboardSummary({
    required this.accountHolderName,
    required this.designation,
    required this.email,
    this.profileImageBase64,
    required this.availableBalance,
    required this.currency,
    required this.quickActions,
    required this.transactions,
  });

  DashboardSummary copyWith({
    String? accountHolderName,
    String? designation,
    String? email,
    String? profileImageBase64,
    double? availableBalance,
    String? currency,
    List<QuickAction>? quickActions,
    List<Transaction>? transactions,
  }) {
    return DashboardSummary(
      accountHolderName: accountHolderName ?? this.accountHolderName,
      designation: designation ?? this.designation,
      email: email ?? this.email,
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
      availableBalance: availableBalance ?? this.availableBalance,
      currency: currency ?? this.currency,
      quickActions: quickActions ?? this.quickActions,
      transactions: transactions ?? this.transactions,
    );
  }
}
