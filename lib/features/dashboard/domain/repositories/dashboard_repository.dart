import '../entities/dashboard_summary.dart';

/// Contract that the presentation layer depends on.
/// Lives in domain — not in data — so the dependency points inward:
/// presentation → domain ← data.
abstract class DashboardRepository {
  /// Emits dashboard snapshots. Implementations may stream live updates
  /// (mock drift, WebSocket, polling) or emit a single snapshot.
  Stream<DashboardSummary> watchDashboard();
}

