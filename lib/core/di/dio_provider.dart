import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Single shared Dio instance. Only ever consumed by Remote* repositories —
/// Mock repositories have no reason to depend on it.
final dioProvider = Provider<Dio>((ref) => Dio());
