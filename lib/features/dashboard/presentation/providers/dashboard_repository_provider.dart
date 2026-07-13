import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/environment/app_environment.dart';
import '../../../../core/environment/environment_config.dart';
import '../../../../core/di/dio_provider.dart';
import '../../data/datasource/dashboard_local_datasource.dart';
import '../../data/repositories/mock_dashboard_repository_impl.dart';
import '../../data/repositories/remote_dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/watch_dashboard_usecase.dart';

/// The only place that knows about Mock vs Remote. Everything downstream —
/// use cases, providers, pages, widgets — depends solely on [DashboardRepository].
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  switch (EnvironmentConfig.current) {
    case AppEnvironment.mock:
      return MockDashboardRepositoryImpl(DashboardLocalDatasource());
    case AppEnvironment.remote:
      return RemoteDashboardRepositoryImpl(ref.watch(dioProvider));
  }
});

final watchDashboardUseCaseProvider = Provider<WatchDashboardUseCase>((ref) {
  return WatchDashboardUseCase(ref.watch(dashboardRepositoryProvider));
});
