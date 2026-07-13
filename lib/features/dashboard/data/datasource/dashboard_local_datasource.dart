import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../dto/dashboard_summary_dto.dart';

/// Handles raw data access — in this case loading from bundled mock assets.
/// For a real backend this would be replaced by an API datasource using Dio.
class DashboardLocalDatasource {
  Future<DashboardSummaryDto> loadDashboard() async {
    final raw = await rootBundle.loadString('assets/mock/dashboard.json');
    return DashboardSummaryDto.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}

