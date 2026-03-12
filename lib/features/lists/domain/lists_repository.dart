import 'package:fpdart/fpdart.dart';
import '../../../core/network/api_error.dart';
import 'entities/ranked_list.dart';

abstract class ListsRepository {
  Future<Either<ApiError, List<ListSummary>>> getLists();

  Future<Either<ApiError, RankedList>> getListDetail(String listId);

  Future<Either<ApiError, RankedList>> createList({
    required String title,
    String? description,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
  });

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
}
