import 'ranked_list.dart';

/// One page of `GET /lists/public` results.
///
/// The backend paginates by keyset and returns the cursor for the following
/// page in the `X-Next-Cursor` response header. [nextCursor] is null on the
/// last page.
class PublicListsPage {
  final List<ListSummary> items;
  final String? nextCursor;

  const PublicListsPage({required this.items, this.nextCursor});

  bool get hasMore => nextCursor != null;
}
