import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _bookmarksKey = 'bookmarked_list_ids';

final bookmarkProvider =
    NotifierProvider<BookmarkNotifier, Set<String>>(BookmarkNotifier.new);

class BookmarkNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    _loadFromPrefs();
    return {};
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_bookmarksKey);
    if (ids != null && ids.isNotEmpty) {
      state = ids.toSet();
    }
  }

  void toggle(String listId) {
    if (state.contains(listId)) {
      state = {...state}..remove(listId);
    } else {
      state = {...state, listId};
    }
    _saveToPrefs();
  }

  bool isBookmarked(String listId) => state.contains(listId);

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_bookmarksKey, state.toList());
  }
}
