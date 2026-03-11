import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/ranked_list.dart';
import '../../domain/lists_repository.dart';
import '../../domain/use_cases/create_list_use_case.dart';
import '../../domain/use_cases/get_list_detail_use_case.dart';
import '../../domain/use_cases/get_lists_use_case.dart';
import '../../domain/use_cases/get_invite_preview_use_case.dart';
import '../../domain/use_cases/join_by_invite_use_case.dart';
import '../../../entries/domain/entities/entry.dart';
import '../../../entries/domain/use_cases/submit_entry_use_case.dart';

// --- Home screen list ---

final listsProvider =
    AsyncNotifierProvider<ListsNotifier, List<ListSummary>>(ListsNotifier.new);

class ListsNotifier extends AsyncNotifier<List<ListSummary>> {
  @override
  Future<List<ListSummary>> build() async {
    final result = await GetIt.instance<GetListsUseCase>().call();
    return result.fold(
      (error) => throw error,
      (lists) => lists,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> createList({
    required String title,
    String? description,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
  }) async {
    final result = await GetIt.instance<CreateListUseCase>().call(
      title: title,
      description: description,
      valueType: valueType,
      rankOrder: rankOrder,
      isPublic: isPublic,
    );
    result.fold(
      (error) => throw error,
      (_) => ref.invalidateSelf(),
    );
  }
}

// --- List detail ---

final listDetailProvider = AsyncNotifierProvider.family<ListDetailNotifier,
    RankedList, String>(ListDetailNotifier.new);

class ListDetailNotifier extends FamilyAsyncNotifier<RankedList, String> {
  @override
  Future<RankedList> build(String arg) async {
    final result = await GetIt.instance<GetListDetailUseCase>().call(arg);
    return result.fold(
      (error) => throw error,
      (list) => list,
    );
  }

  Future<void> submitEntry(EntryInput input) async {
    final result = await GetIt.instance<SubmitEntryUseCase>().call(
      listId: arg,
      input: input,
    );
    result.fold(
      (error) => throw error,
      (_) => ref.invalidateSelf(),
    );
  }
}

// --- Invite preview ---

final invitePreviewProvider = AsyncNotifierProvider.family<
    InvitePreviewNotifier, RankedList, String>(InvitePreviewNotifier.new);

class InvitePreviewNotifier extends FamilyAsyncNotifier<RankedList, String> {
  @override
  Future<RankedList> build(String arg) async {
    final result =
        await GetIt.instance<GetInvitePreviewUseCase>().call(arg);
    return result.fold(
      (error) => throw error,
      (list) => list,
    );
  }

  Future<RankedList> join() async {
    final result = await GetIt.instance<JoinByInviteUseCase>().call(arg);
    return result.fold(
      (error) => throw error,
      (list) => list,
    );
  }
}

// --- Members ---

final membersProvider = AsyncNotifierProvider.family<MembersNotifier,
    List<ListMember>, String>(MembersNotifier.new);

class MembersNotifier extends FamilyAsyncNotifier<List<ListMember>, String> {
  @override
  Future<List<ListMember>> build(String arg) async {
    final repo = GetIt.instance<ListsRepository>();
    final result = await repo.getMembers(arg);
    return result.fold(
      (error) => throw error,
      (members) => members,
    );
  }

  Future<void> updateRole({
    required String userId,
    required MemberRole role,
  }) async {
    final repo = GetIt.instance<ListsRepository>();
    final result = await repo.updateMemberRole(
      listId: arg,
      userId: userId,
      role: role,
    );
    result.fold(
      (error) => throw error,
      (_) => ref.invalidateSelf(),
    );
  }

  Future<void> removeMember(String userId) async {
    final repo = GetIt.instance<ListsRepository>();
    final result = await repo.removeMember(listId: arg, userId: userId);
    result.fold(
      (error) => throw error,
      (_) => ref.invalidateSelf(),
    );
  }
}
