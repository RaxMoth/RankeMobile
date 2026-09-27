import 'package:fpdart/fpdart.dart';

import '../../../core/network/api_error.dart';
import '../../profile/domain/entities/user_profile.dart';
import 'entities/public_lists_page.dart';
import 'entities/ranked_list.dart';

/// Abstract lists repository interface
abstract class ListsRepository {
  Future<Either<ApiError, List<ListSummary>>> getLists();

  Future<Either<ApiError, RankedList>> getListDetail(String listId);

  Future<Either<ApiError, RankedList>> createList({
    required String title,
    String? description,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
    String? category,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  });

  Future<Either<ApiError, void>> deleteList(String listId);

  /// Joins a public board (idempotent).
  Future<Either<ApiError, void>> joinList(String listId);

  /// Leaves a board; the caller's entry is removed. Owners can't leave.
  Future<Either<ApiError, void>> leaveList(String listId);

  Future<Either<ApiError, RankedList>> getInvitePreview(String token);

  Future<Either<ApiError, void>> joinByInvite(String token);

  /// The ready-to-share invite URL (built by the backend).
  Future<Either<ApiError, String>> getInviteLink(String listId);

  Future<Either<ApiError, List<ListMember>>> getMembers(String listId);

  Future<Either<ApiError, void>> updateMemberRole({
    required String listId,
    required String userId,
    required MemberRole role,
  });

  Future<Either<ApiError, void>> removeMember({
    required String listId,
    required String userId,
  });

  /// Patches a board. A null argument leaves that field unchanged; an empty
  /// string clears an optional one (description, category, links).
  Future<Either<ApiError, RankedList>> updateList({
    required String listId,
    String? title,
    String? description,
    bool? isPublic,
    bool? locked,
    String? category,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  });

  Future<Either<ApiError, void>> deleteEntry({
    required String listId,
    required String entryId,
  });

  /// Sets a text board's ranking: [orderedEntryIds] best first (#1 first).
  Future<Either<ApiError, void>> reorderEntries({
    required String listId,
    required List<String> orderedEntryIds,
  });

  Future<Either<ApiError, String>> regenerateInvite(String listId);

  /// Fetches one page of public boards. Pass the previous page's
  /// [PublicListsPage.nextCursor] as [cursor] to continue; omit it for the
  /// first page. [limit] defaults to the server's page size when null.
  Future<Either<ApiError, PublicListsPage>> searchPublicLists({
    String? query,
    String? category,
    String? cursor,
    int? limit,
  });

  Future<Either<ApiError, UserProfile>> getUserProfile(String userId);
}
