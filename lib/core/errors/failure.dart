/// Sealed-style failure hierarchy for surfacing errors to the UI without
/// leaking raw exceptions into presentation code.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Connection lost. Check your network and try again.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong. Please try again.']);
}
