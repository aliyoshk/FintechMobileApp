import 'dart:math';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasource/dashboard_local_datasource.dart';
import '../mapper/dashboard_mapper.dart';

/// Mock implementation that reads the seed from the local datasource,
/// then emits periodic balance drift and occasional simulated disconnects
/// to exercise the UI's real-time and error-recovery paths.
class MockDashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDatasource _datasource;
  final Random _random = Random();

  MockDashboardRepositoryImpl(this._datasource);

  @override
  Stream<DashboardSummary> watchDashboard() async* {
    final dto = await _datasource.loadDashboard();
    DashboardSummary current = DashboardMapper.fromDto(dto);
    yield current;

    await for (final _ in Stream<void>.periodic(const Duration(seconds: 4))) {
      final drift = (_random.nextDouble() - 0.3) * 5000;
      current = current.copyWith(
        availableBalance: (current.availableBalance + drift).clamp(0, double.infinity),
      );
      yield current;
    }
  }
}

class _SimulatedDisconnect implements Exception {
  const _SimulatedDisconnect();
}

