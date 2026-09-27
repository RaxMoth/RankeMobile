import 'dart:async';

/// App-wide signal that the stored session can no longer be used — the
/// access token was rejected and refreshing it failed. The auth layer
/// listens and signs the user out, so the router sends them to login
/// instead of leaving them on screens where every call fails.
class SessionEvents {
  final _expired = StreamController<void>.broadcast();

  Stream<void> get expired => _expired.stream;

  void notifyExpired() => _expired.add(null);

  Future<void> dispose() => _expired.close();
}
