import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction.dart';

const Map<String, dynamic> _categoryIcons = {
  'wallet': 'assets/icons/ic_ewallet.png',
  'shopping': 'assets/icons/ic_online_shopping.png',
  'bank': Icons.account_balance_rounded,
  'saving': Icons.savings_rounded,
};

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.isCredit;
    final amountColor = isCredit ? AppColors.success : AppColors.error;
    final sign = isCredit ? '+' : '-';
    final iconAsset = _categoryIcons[transaction.category] ?? Icons.receipt_long_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
            padding: const EdgeInsets.all(1),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _buildIcon(iconAsset),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTextStyles.body.copyWith(color: Colors.white)),
                Text(
                  '${DateFormat('h:mm a').format(transaction.timestamp).toLowerCase()} · ${DateFormat('dd-MM-yyyy').format(transaction.timestamp)}',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Text(
            '$sign ${CurrencyFormatter.formatAmount(transaction.amount.abs())}',
            style: AppTextStyles.body.copyWith(color: amountColor, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(dynamic iconData) {
    if (iconData is String) {
      return Image.asset(iconData, width: 18, height: 18, color: Colors.white);
    }
    return Icon(iconData as IconData? ?? Icons.receipt_long_rounded, size: 18, color: Colors.white);
  }
}
