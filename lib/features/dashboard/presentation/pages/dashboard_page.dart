import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/profile_drawer.dart';
import '../widgets/quick_actions.dart';
import '../widgets/total_balance_card.dart';
import '../widgets/transaction_filter_chips.dart';
import '../widgets/transaction_tile.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  TransactionFilter _filter = TransactionFilter.weekly;

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
                    ),
                    dashboardAsync.maybeWhen(
                      data: (d) => Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: 'Welcome ', style: TextStyle(fontSize: 15)),
                            TextSpan(text: d.accountHolderName, style: AppTextStyles.welcomeName),
                          ],
                        ),
                      ),
                      orElse: () => const SizedBox.shrink(),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                          child: Image.asset('assets/icons/ic_bell.png', width: 20, height: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: dashboardAsync.when(
                loading: () => const _DashboardSkeleton(),
                error: (error, _) => _DashboardError(
                  onRetry: () => ref.invalidate(dashboardStreamProvider),
                ),
                data: (dashboard) => RefreshIndicator(
                  onRefresh: () async => ref.invalidate(dashboardStreamProvider),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    children: [
                      TotalBalanceCard(
                        balance: dashboard.availableBalance,
                        onAddCash: () {},
                        onSendMoney: () {},
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      QuickActions(actions: dashboard.quickActions),
                      const SizedBox(height: AppSpacing.lg),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Transaction History', style: AppTextStyles.sectionTitle),
                          Text('See all', style: AppTextStyles.link),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TransactionFilterChips(
                        selected: _filter,
                        onChanged: (f) => setState(() => _filter = f),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (int i = 0; i < dashboard.transactions.length; i++)
                        _StaggeredEntry(
                          index: i,
                          child: TransactionTile(transaction: dashboard.transactions[i]),
                        ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredEntry extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredEntry({required this.index, required this.child});

  @override
  State<_StaggeredEntry> createState() => _StaggeredEntryState();
}

class _StaggeredEntryState extends State<_StaggeredEntry> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 40 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: widget.child,
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          const ShimmerLoader(height: 180),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: List.generate(
              4,
               (i) => const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: ShimmerLoader(height: 52, borderRadius: BorderRadius.all(Radius.circular(26))),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (int i = 0; i < 4; i++)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: ShimmerLoader(height: 56),
            ),
        ],
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  final VoidCallback onRetry;

  const _DashboardError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ErrorBanner(
          message: 'Lost connection to your dashboard.',
          onRetry: onRetry,
        ),
      ),
    );
  }
}
