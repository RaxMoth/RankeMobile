import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lists/presentation/providers/lists_provider.dart';

/// Submissions waiting for the viewer's review across all their boards,
/// shown as a badge on the HOME tab. The backend only counts boards the
/// viewer can review (owner/admin/moderator).
final pendingCountProvider = Provider<int>((ref) {
  return ref
      .watch(listsProvider)
      .maybeWhen(
        data: (lists) => lists.fold(0, (sum, l) => sum + l.pendingCount),
        orElse: () => 0,
      );
});
