/// Dev-mode configuration.
///
/// The app swaps real HTTP repos for in-memory mock repos when [useMocks]
/// is true. This MUST be controlled via `--dart-define=USE_MOCK=true` so
/// release builds are physically incapable of shipping with mocks unless a
/// developer passes the flag.
///
/// Production builds (App Store TestFlight + release):
///   flutter build ios --release
///   → USE_MOCK defaults to `false` → real backend.
///
/// Local UI work without a backend:
///   flutter run --dart-define=USE_MOCK=true
abstract class DevConfig {
  /// Whether to use mock repositories instead of real HTTP data sources.
  ///
  /// Defaults to `false` so omitting the flag in a release build is safe.
  static const bool useMocks = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: false,
  );

  /// Simulated network delay to make mock interactions feel realistic.
  static const Duration networkDelay = Duration(milliseconds: 400);
}
