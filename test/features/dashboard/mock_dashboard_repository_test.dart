import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn_dashboard/features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'package:mintyn_dashboard/features/dashboard/data/repositories/mock_dashboard_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MockDashboardRepository', () {
    test('emits an initial dashboard snapshot loaded from the mock asset', () async {
      final repository = MockDashboardRepositoryImpl(DashboardLocalDatasource());

      final first = await repository.watchDashboard().first;

      expect(first.accountHolderName, isNotEmpty);
      expect(first.availableBalance, greaterThan(0));
      expect(first.transactions, isNotEmpty);
    });

    test('subsequent emissions keep the same account holder while balance may drift', () async {
      // The mock randomly throws ~1-in-6 ticks to simulate disconnects.
      // Retry up to 3 times so the test isn't flaky.
      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          final repository = MockDashboardRepositoryImpl(DashboardLocalDatasource());
          final emissions = await repository.watchDashboard().take(2).toList();

          expect(emissions.length, 2);
          expect(emissions[0].accountHolderName, emissions[1].accountHolderName);
          return; // success
        } catch (_) {
          if (attempt == 2) rethrow;
        }
      }
    });
  });
}
