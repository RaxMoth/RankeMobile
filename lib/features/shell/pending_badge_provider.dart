import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lists/domain/entities/ranked_list.dart';
import '../lists/presentation/providers/lists_provider.dart';

/// Counts total pending entries across all boards the user owns/admins.
/// Used to show a badge dot on the HOME tab.
final pendingCountProvider = Provider<int>((ref) {
  final listsAsync = ref.watch(listsProvider);
  return listsAsync.maybeWhen(
    data: (lists) {
      // For each admin/owner board, check if it has pending entries
      // Since we only have summaries here, we rely on list detail cache.
      // For now, check cached detail providers for pending entries.
      int count = 0;
      for (final summary in lists) {
        if (summary.currentUserRole == MemberRole.owner ||
            summary.currentUserRole == MemberRole.admin) {
          final detail = ref.watch(listDetailProvider(summary.id));
          detail.whenData((list) {
            count += list.pendingEntries.length;
          });
        }
      }
      return count;
    },
    orElse: () => 0,
  );
});
