import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../cards/presentation/pages/cards_page.dart';
import '../providers/dashboard_provider.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardStreamProvider);

    return Drawer(
      backgroundColor: AppColors.background,
      width: MediaQuery.of(context).size.width * 0.7,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const SizedBox(height: AppSpacing.md),
            dashboardAsync.when(
              data: (dashboard) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: AppColors.surfaceElevated,
                        child: Icon(Icons.person_rounded,
                            color: AppColors.textPrimary, size: 35),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.background, width: 2),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.edit,
                              size: 10, color: AppColors.primaryBlue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    dashboard.accountHolderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    dashboard.designation,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    dashboard.email,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              loading: () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.surfaceElevated,
                    child: Icon(Icons.person_rounded,
                        color: AppColors.textPrimary, size: 35),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                      width: 60,
                      height: 12,
                      decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 4),
                  Container(
                      width: 140,
                      height: 18,
                      decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 4),
                  Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 4),
                  Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(4))),
                ],
              ),
              error: (err, stack) => Column(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  Text(err.toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: AppSpacing.lg),
            const Text('Profile Settings', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            const _DrawerRow(
                icon: Icons.description_outlined, label: 'E-Statement'),
            _DrawerRow(
              icon: Icons.credit_card_outlined,
              label: 'Credit Card',
              onTap: () {
                Navigator.of(context).pop(); // close drawer
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CardsPage()),
                );
              },
            ),
            const _DrawerRow(icon: Icons.settings_outlined, label: 'Settings'),
            const SizedBox(height: AppSpacing.lg),
            const Text('Notification', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            _NotificationRow(),
            const SizedBox(height: AppSpacing.lg),
            const Text('More', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            const _DrawerRow(icon: Icons.translate_rounded, label: 'Language'),
            const _DrawerRow(icon: Icons.public_rounded, label: 'Country'),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: AppColors.logoutPink,
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Logout',
                            style: TextStyle(
                                color: AppColors.logoutText,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        SizedBox(width: 8),
                        Icon(Icons.logout_rounded,
                            color: AppColors.logoutText, size: 20),
                      ],
                    ),
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

class _DrawerRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _DrawerRow({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
            color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(label, style: AppTextStyles.body)),
            const Icon(Icons.chevron_right_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}

class _NotificationRow extends StatefulWidget {
  @override
  State<_NotificationRow> createState() => _NotificationRowState();
}

class _NotificationRowState extends State<_NotificationRow> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_outlined,
              color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(
              child: Text('App Notification', style: AppTextStyles.body)),
          GestureDetector(
            onTap: () => setState(() => _enabled = !_enabled),
            child: AppSwitch(value: _enabled),
          ),
        ],
      ),
    );
  }
}
