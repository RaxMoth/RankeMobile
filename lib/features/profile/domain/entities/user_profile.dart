import '../../../lists/domain/entities/ranked_list.dart';

/// Public user profile — viewable by any authenticated user.
class UserProfile {
  final String userId;
  final String displayName;
  final DateTime? memberSince;
  final List<ListSummary> boards;

  const UserProfile({
    required this.userId,
    required this.displayName,
    this.memberSince,
    required this.boards,
  });
}
