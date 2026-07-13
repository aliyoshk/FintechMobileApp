import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

/// Single-responsibility use case: watch the live dashboard feed.
///
/// Even with only one line of delegation today, this gives us a clear
/// seam for adding cross-cutting concerns (caching, analytics, logging)
/// without touching the repository or the provider.
class WatchDashboardUseCase {
  final DashboardRepository _repository;

  const WatchDashboardUseCase(this._repository);

  Stream<DashboardSummary> call() => _repository.watchDashboard();
}

