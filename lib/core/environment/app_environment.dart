/// Which data source the app is wired to. Mock is the default for this
/// assessment since there is no live Mintyn API to call, but the app is
/// structured so switching to `remote` requires no UI or provider changes —
/// only a build-time flag and a real repository implementation.
enum AppEnvironment { mock, remote }
