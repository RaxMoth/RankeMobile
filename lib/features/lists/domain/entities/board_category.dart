/// Board categories offered when creating/editing a board and used as
/// Discover filters. Stored on the backend as the plain string.
abstract class BoardCategory {
  static const finance = 'FINANCE';
  static const fitness = 'FITNESS';
  static const coding = 'CODING';
  static const health = 'HEALTH';
  static const gaming = 'GAMING';
  static const education = 'EDUCATION';

  static const all = [finance, fitness, coding, health, gaming, education];
}
