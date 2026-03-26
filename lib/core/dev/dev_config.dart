/// Dev mode configuration.
/// Set [useDevMode] to true to use mock repositories with fake data
/// instead of hitting the real backend.
class DevConfig {
  /// Toggle this to switch between mock data and real API.
  static const bool useDevMode = true;

  /// Simulated network delay to make interactions feel realistic.
  static const Duration networkDelay = Duration(milliseconds: 400);
}
