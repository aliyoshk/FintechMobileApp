import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dashboard_summary.dart';
import 'dashboard_repository_provider.dart';

/// StreamProvider gives us AsyncValue<DashboardSummary> for free — loading,
/// data, and error states are handled uniformly in the UI via .when().
///
/// Routes through the [WatchDashboardUseCase] rather than calling the
/// repository directly — keeping the Clean Architecture dependency chain:
/// Provider → UseCase → Repository Interface → Repository Implementation.
final dashboardStreamProvider = StreamProvider.autoDispose<DashboardSummary>((ref) {
  final useCase = ref.watch(watchDashboardUseCaseProvider);
  return useCase();
});
