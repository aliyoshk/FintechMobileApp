import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../providers/cards_provider.dart';
import '../widgets/card_carousel.dart';
import 'card_transaction_page.dart';

class CardsPage extends ConsumerStatefulWidget {
  const CardsPage({super.key});

  @override
  ConsumerState<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends ConsumerState<CardsPage> {
  bool _showVirtual = false;
  bool _revealed = false;
  int _activeIndex = 1;

  int _preferredStartIndex(int cardCount) {
    return cardCount >= 3 ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardsStreamProvider);
    final toggleFreeze = ref.watch(toggleFreezeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: cardsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: ShimmerLoader(height: 200),
          ),
          error: (error, _) => Center(
            child: ErrorBanner(
              message: 'Could not load your cards.',
              onRetry: () => ref.invalidate(cardsStreamProvider),
            ),
          ),
          data: (allCards) {
            final physicalCards = allCards.where((c) => !c.isVirtual).toList();
            final virtualCards = allCards.where((c) => c.isVirtual).toList();
            final visibleCards = _showVirtual ? virtualCards : physicalCards;
            final activeCard = visibleCards.isEmpty
                ? null
                : visibleCards[_activeIndex.clamp(0, visibleCards.length - 1)];

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Card',
                            style: AppTextStyles.screenTitle),
                        Text(
                          '${physicalCards.length} Physical Card, ${virtualCards.length} Virtual Card',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    const Icon(Icons.more_horiz_rounded,
                        color: AppColors.textSecondary),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _CardTypeToggle(
                  showVirtual: _showVirtual,
                  onChanged: (v) => setState(() {
                    final nextCards = v ? virtualCards : physicalCards;
                    _showVirtual = v;
                    _activeIndex = _preferredStartIndex(nextCards.length);
                  }),
                ),
                const SizedBox(height: 32),
                if (visibleCards.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Center(
                        child: Text('No cards in this category yet.',
                            style: AppTextStyles.body)),
                  )
                else ...[
                  CardCarousel(
                    key: ValueKey('${_showVirtual}_${visibleCards.length}'),
                    cards: visibleCards,
                    revealed: _revealed,
                    onPageChanged: (i) => setState(() => _activeIndex = i),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _PageDots(
                      count: visibleCards.length, activeIndex: _activeIndex),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CircleAction(
                        icon: Icons.ac_unit_rounded,
                        label: 'Freeze Card',
                        onTap: () => toggleFreeze(activeCard!.id),
                      ),
                      _CircleAction(
                        icon: _revealed
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        label: _revealed ? 'Hide' : 'Reveal',
                        active: _revealed,
                        onTap: () => setState(() => _revealed = !_revealed),
                      ),
                      _CircleAction(
                        icon: Icons.tune_rounded,
                        label: 'Manage',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 28),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 20),
                const Text(
                  'Card Settings',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const _SettingsToggleRow(
                    icon: Icons.password_rounded,
                    label: 'Change Pin',
                    initialValue: true),
                const _SettingsToggleRow(
                    icon: Icons.qr_code_rounded,
                    label: 'QR Payment',
                    initialValue: true),
                const _SettingsToggleRow(
                    icon: Icons.storefront_rounded,
                    label: 'Online Shopping',
                    initialValue: false),
                _SettingsNavRow(
                  icon: Icons.credit_card_rounded,
                  label: 'Card Transactions',
                  onTap: activeCard == null
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    CardTransactionPage(card: activeCard)),
                          ),
                ),
                const _SettingsToggleRow(
                    icon: Icons.contactless_rounded,
                    label: 'Tap Pay',
                    initialValue: true),
                const SizedBox(height: AppSpacing.lg),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CardTypeToggle extends StatelessWidget {
  final bool showVirtual;
  final ValueChanged<bool> onChanged;

  const _CardTypeToggle({required this.showVirtual, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ToggleChip(
            label: 'Physical Card',
            selected: !showVirtual,
            onTap: () => onChanged(false)),
        const SizedBox(width: AppSpacing.sm),
        _ToggleChip(
            label: 'Virtual Card',
            selected: showVirtual,
            onTap: () => onChanged(true)),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AppColors.primaryBlue : Colors.transparent),
          color: AppColors.surface,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _PageDots({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.primaryBlue : Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _CircleAction(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? AppColors.primaryBlue.withValues(alpha: 0.15)
                  : AppColors.surfaceElevated,
              border: active ? Border.all(color: AppColors.primaryBlue) : null,
            ),
            child: Icon(icon,
                color: active ? AppColors.primaryBlue : Colors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            width: 84,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption
                  .copyWith(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsToggleRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool initialValue;

  const _SettingsToggleRow(
      {required this.icon, required this.label, required this.initialValue});

  @override
  State<_SettingsToggleRow> createState() => _SettingsToggleRowState();
}

class _SettingsToggleRowState extends State<_SettingsToggleRow> {
  late bool _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      icon: widget.icon,
      label: widget.label,
      onTap: () => setState(() => _value = !_value),
      trailing: IgnorePointer(
        child: AppSwitch(value: _value),
      ),
    );
  }
}

class _SettingsNavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SettingsNavRow(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _SettingsRowShell(
        icon: icon,
        label: label,
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textPrimary, size: 24),
      ),
    );
  }
}

class _SettingsRowShell extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsRowShell(
      {required this.icon,
      required this.label,
      required this.trailing,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 56,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
