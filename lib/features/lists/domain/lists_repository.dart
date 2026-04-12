import 'package:fpdart/fpdart.dart';

import '../../../core/network/api_error.dart';
import '../../profile/domain/entities/user_profile.dart';
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
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  });

  Future<Either<ApiError, void>> deleteList(String listId);

  Future<Either<ApiError, RankedList>> getInvitePreview(String token);

  Future<Either<ApiError, void>> joinByInvite(String token);

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

  Future<Either<ApiError, RankedList>> updateList({
    required String listId,
    String? title,
    String? description,
    bool? isPublic,
    bool? locked,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  });

  Future<Either<ApiError, void>> deleteEntry({
    required String listId,
    required String entryId,
  });

  Future<Either<ApiError, String>> regenerateInvite(String listId);

  Future<Either<ApiError, List<ListSummary>>> searchPublicLists({
    String? query,
    String? category,
  });

  Future<Either<ApiError, UserProfile>> getUserProfile(String userId);
}
