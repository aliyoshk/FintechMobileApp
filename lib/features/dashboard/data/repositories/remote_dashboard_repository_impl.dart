import 'package:dio/dio.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Production stub — demonstrates the architecture supports swapping to a
/// real backend via environment config with zero UI changes.
class RemoteDashboardRepositoryImpl implements DashboardRepository {
  // ignore: unused_field
  final Dio _dio;

  RemoteDashboardRepositoryImpl(this._dio);

  @override
  Stream<DashboardSummary> watchDashboard() {
    throw UnimplementedError(
      'RemoteDashboardRepositoryImpl is a stub — no live backend for this assessment.',
    );
  }
}

