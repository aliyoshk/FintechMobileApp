import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn_dashboard/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:mintyn_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:mintyn_dashboard/features/dashboard/domain/usecases/watch_dashboard_usecase.dart';

class _FakeRepository implements DashboardRepository {
  @override
  Stream<DashboardSummary> watchDashboard() {
    return Stream.value(
      const DashboardSummary(
        accountHolderName: 'Test',
        designation: 'Developer',
        email: 'test@example.com',
        availableBalance: 500,
        currency: 'USD',
        quickActions: [],
        transactions: [],
      ),
    );
  }
}

void main() {
  group('WatchDashboardUseCase', () {
    test('delegates to repository and emits its data', () async {
      final useCase = WatchDashboardUseCase(_FakeRepository());

      final result = await useCase().first;

      expect(result.accountHolderName, 'Test');
      expect(result.availableBalance, 500);
    });
  });
}
