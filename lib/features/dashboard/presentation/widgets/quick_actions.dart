import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/quick_action.dart';

const Map<String, dynamic> _iconMap = {
  'bill_pay': 'assets/icons/ic_bill_pay.png',
  'donations': 'assets/icons/ic_donation.png',
  'deposit': 'assets/icons/ic_deposit.png',
  'more': Icons.grid_view_rounded,
};

class QuickActions extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActions({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final action in actions) _QuickActionButton(action: action),
      ],
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final QuickAction action;

  const _QuickActionButton({required this.action});

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.92),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () {},
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
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
                  child: _buildIcon(widget.action.icon),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.action.label,
              style: AppTextStyles.caption.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String iconKey) {
    final iconData = _iconMap[iconKey];
    if (iconData is String) {
      return Image.asset(
        iconData,
        width: 22,
        height: 22,
        color: Colors.white,
      );
    }
    return Icon(
      iconData as IconData? ?? Icons.circle,
      color: Colors.white,
      size: 22,
    );
  }
}
