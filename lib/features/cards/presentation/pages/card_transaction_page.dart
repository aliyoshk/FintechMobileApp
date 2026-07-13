import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/spending_area_chart.dart';
import '../../../dashboard/presentation/widgets/transaction_tile.dart';
import '../../../dashboard/domain/entities/transaction.dart';
import '../../domain/entities/bank_card.dart';
import '../widgets/bank_card_widget.dart';

/// Drill-down from Cards → "Card Transactions". Scoped under the Cards
/// feature (not a separate top-level tab) since it only exists in the
/// context of a specific card.
class CardTransactionPage extends StatelessWidget {
  final BankCard card;

  const CardTransactionPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    // Same shape of mock transactions as the dashboard, filtered to a
    // card-spend narrative — kept local to this screen since it's
    // presentation-only demo data, not part of the live dashboard feed.
    final transactions = [
      Transaction(id: 'ct1', title: 'E wallet', category: 'wallet', amount: 100, timestamp: DateTime(2024, 12, 12, 12, 10)),
      Transaction(id: 'ct2', title: 'Online Shopping', category: 'shopping', amount: -100, timestamp: DateTime(2024, 12, 12, 12, 10)),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          children: [
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
                    ),
                    const Text('Card Transaction', style: AppTextStyles.screenTitle),
                  ],
                ),
                const Icon(Icons.more_horiz_rounded, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            BankCardWidget(card: card),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Spend', style: AppTextStyles.caption),
                    Text(CurrencyFormatter.formatBalance(30), style: AppTextStyles.sectionTitle),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Weekly', style: TextStyle(color: AppColors.textPrimary, fontSize: 12)),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const SpendingAreaChart(
              values: [40, 55, 90, 75, 82, 100],
              labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
              highlightIndex: 1,
              highlightValue: '\$3,657',
            ),
            const SizedBox(height: AppSpacing.lg),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transaction History', style: AppTextStyles.sectionTitle),
                Text('See all', style: AppTextStyles.link),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final t in transactions) TransactionTile(transaction: t),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
