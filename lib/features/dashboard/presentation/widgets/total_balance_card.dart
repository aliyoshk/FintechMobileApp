import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';


class TotalBalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback onAddCash;
  final VoidCallback onSendMoney;

  const TotalBalanceCard({
    super.key,
    required this.balance,
    required this.onAddCash,
    required this.onSendMoney,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = CurrencyFormatter.formatBalance(balance);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: _MastercardMark(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Balance', style: AppTextStyles.welcomeName),
                  const SizedBox(height: AppSpacing.sm),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Text(formatted, key: ValueKey(formatted), style: AppTextStyles.balanceAmount),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppColors.surfaceElevated, shape: BoxShape.circle),
                  child: const Icon(Icons.qr_code_rounded, size: 24, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _PillButton(icon: Icons.add_rounded, label: 'Add Cash', onTap: onAddCash),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _PillButton(icon: Icons.north_east_rounded, label: 'Send Money', onTap: onSendMoney),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PillButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryBlue,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 17),
              const SizedBox(width: 2),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MastercardMark extends StatelessWidget {
  const _MastercardMark();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 50,
          height: 30,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: Container(width: 28, height: 28, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle)),
              ),
              Positioned(
                left: 20,
                child: Container(width: 28, height: 28, decoration: BoxDecoration(color: const Color(0xFFF79E1B).withValues(alpha: 0.9), shape: BoxShape.circle)),
              ),
            ],
          ),
        ),
        const Text(
          'mastercard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
