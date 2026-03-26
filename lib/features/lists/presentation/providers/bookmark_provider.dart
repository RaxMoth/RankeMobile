import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-memory bookmark state. Resets on app restart.
/// Later can be backed by SharedPreferences or API.
final bookmarkProvider =
    NotifierProvider<BookmarkNotifier, Set<String>>(BookmarkNotifier.new);

class BookmarkNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String listId) {
    if (state.contains(listId)) {
      state = {...state}..remove(listId);
    } else {
      state = {...state, listId};
    }
  }

  bool isBookmarked(String listId) => state.contains(listId);
}
