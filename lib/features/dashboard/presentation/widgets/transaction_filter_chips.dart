import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum TransactionFilter { weekly, monthly, today }

class TransactionFilterChips extends StatelessWidget {
  final TransactionFilter selected;
  final ValueChanged<TransactionFilter> onChanged;

  const TransactionFilterChips({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final filter in TransactionFilter.values) ...[
          _Chip(
            label: switch (filter) {
              TransactionFilter.weekly => 'Weekly',
              TransactionFilter.monthly => 'Monthly',
              TransactionFilter.today => 'Today',
            },
            selected: filter == selected,
            onTap: () => onChanged(filter),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceElevated : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
