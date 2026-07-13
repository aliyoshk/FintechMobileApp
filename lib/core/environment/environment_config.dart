import 'app_environment.dart';

/// Reads the active environment from a compile-time flag.
///
/// Usage:
///   flutter run                              -> defaults to mock
///   flutter run --dart-define=ENV=remote      -> would use the remote repository
///
/// This keeps the decision at the edge of the app (build configuration)
/// rather than scattered through business logic or UI code.
class EnvironmentConfig {
  EnvironmentConfig._();

  static const String _raw = String.fromEnvironment('ENV', defaultValue: 'mock');

  static AppEnvironment get current =>
      _raw == 'remote' ? AppEnvironment.remote : AppEnvironment.mock;

  static bool get isMock => current == AppEnvironment.mock;
}
