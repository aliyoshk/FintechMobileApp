import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn_dashboard/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:mintyn_dashboard/features/dashboard/domain/entities/transaction.dart';
import 'package:mintyn_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:mintyn_dashboard/features/dashboard/presentation/providers/dashboard_repository_provider.dart';
import 'package:mintyn_dashboard/features/dashboard/presentation/pages/dashboard_page.dart';


class _FakeDashboardRepository implements DashboardRepository {
  @override
  Stream<DashboardSummary> watchDashboard() {
    return Stream.value(
      DashboardSummary(
        accountHolderName: 'Test User',
        designation: 'QA Engineer',
        email: 'test@example.com',
        availableBalance: 100000,
        currency: 'NGN',
        quickActions: const [],
        transactions: [
          Transaction(id: 't1', title: 'Test Transaction', category: 'Test', amount: -500, timestamp: DateTime(2026, 1, 1)),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('DashboardScreen renders balance and transactions from stream', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(_FakeDashboardRepository()),
        ],
        child: const MaterialApp(home: DashboardPage()),
      ),
    );

    // Let StreamProvider settle and staggered animation timers complete.
    await tester.pumpAndSettle();

    expect(find.text('Transaction History'), findsOneWidget);
    expect(find.text('Test Transaction'), findsOneWidget);
  });
}
