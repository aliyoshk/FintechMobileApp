import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/bank_card.dart';

class BankCardWidget extends StatelessWidget {
  final BankCard card;
  final bool revealed;

  const BankCardWidget({super.key, required this.card, this.revealed = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: card.isFrozen ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (card.isFrozen)
                  const Icon(Icons.ac_unit_rounded,
                      color: Colors.white54, size: 20)
                else
                  const SizedBox(width: 20, height: 20),
                const _MastercardLogo(),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8B26B),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(Icons.dashboard_customize_rounded,
                      size: 14, color: Color(0xFF6E5220)),
                ),
                const SizedBox(width: AppSpacing.sm),
                const RotatedBox(
                  quarterTurns: 1,
                  child:
                      Icon(Icons.wifi_rounded, color: Colors.white54, size: 20),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                revealed ? card.formattedNumber : card.maskedNumber,
                key: ValueKey(revealed),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _CardDetail(
                      label: 'Card Holder', value: card.cardHolderName),
                ),
                Expanded(
                  flex: 4,
                  child: _CardDetail(
                    label: 'Valid',
                    value: card.validDate,
                    valueLetterSpacing: -0.5,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _CardDetail(
                    label: 'CVV',
                    value: revealed ? card.cvv : '•••',
                    valueLetterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardDetail extends StatelessWidget {
  final String label;
  final String value;
  final double? valueLetterSpacing;
  final CrossAxisAlignment alignment;

  const _CardDetail({
    required this.label,
    required this.value,
    this.valueLetterSpacing,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white38, fontSize: 10)),
        const SizedBox(height: 0),
        Text(value,
            textAlign: alignment == CrossAxisAlignment.end
                ? TextAlign.right
                : TextAlign.left,
            style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                letterSpacing: valueLetterSpacing,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _MastercardLogo extends StatelessWidget {
  const _MastercardLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 50,
          height: 24,
          child: Stack(
            children: [
              Positioned(
                left: 8,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                      color: Color(0xFFEB001B), shape: BoxShape.circle),
                ),
              ),
              Positioned(
                left: 20,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                      shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
        const Text(
          'mastercard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 6,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
