import 'package:fpdart/fpdart.dart';
<<<<<<< HEAD
import '../../../core/network/api_error.dart';
import 'entities/ranked_list.dart';

abstract class ListsRepository {
  Future<Either<ApiError, List<ListSummary>>> getLists();
=======

import '../../../core/network/api_error.dart';
import 'entities/ranked_list.dart';

/// Abstract lists repository interface
abstract class ListsRepository {
  Future<Either<ApiError, List<ListSummary>>> getMyLists();
>>>>>>> 88d3438 (good progress)

  Future<Either<ApiError, RankedList>> getListDetail(String listId);

  Future<Either<ApiError, RankedList>> createList({
    required String title,
    String? description,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
  });

<<<<<<< HEAD
  Future<Either<ApiError, RankedList>> getInvitePreview(String token);

  Future<Either<ApiError, RankedList>> joinByInvite(String token);

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
=======
  Future<Either<ApiError, void>> deleteList(String listId);

  Future<Either<ApiError, RankedList>> getInvitePreview(String token);

  Future<Either<ApiError, void>> joinList(String token);

  Future<Either<ApiError, List<ListMember>>> getMembers(String listId);

  Future<Either<ApiError, void>> removeMember(String listId, String userId);

  Future<Either<ApiError, void>> updateMemberRole(
    String listId,
    String userId,
    MemberRole role,
  );
>>>>>>> 88d3438 (good progress)
}
