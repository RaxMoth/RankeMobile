import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../entries/domain/entities/entry.dart';
import '../../../entries/domain/entries_repository.dart';
import '../../../entries/domain/use_cases/approve_submission_use_case.dart';
import '../../../entries/domain/use_cases/get_pending_submissions_use_case.dart';
import '../../../entries/domain/use_cases/reject_submission_use_case.dart';
import '../../../entries/domain/use_cases/submit_entry_use_case.dart';
import '../../domain/entities/ranked_list.dart';
import '../../domain/lists_repository.dart';
import '../../domain/use_cases/create_list_use_case.dart';
import '../../domain/use_cases/get_invite_preview_use_case.dart';
import '../../domain/use_cases/get_list_detail_use_case.dart';
import '../../domain/use_cases/get_lists_use_case.dart';
import '../../domain/use_cases/join_by_invite_use_case.dart';

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
    String? category,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  }) async {
    final result = await GetIt.instance<CreateListUseCase>().call(
      title: title,
      description: description,
      valueType: valueType,
      rankOrder: rankOrder,
      isPublic: isPublic,
      category: category,
      telegramLink: telegramLink,
      whatsappLink: whatsappLink,
      discordLink: discordLink,
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

  /// Queues the caller's entry for review and returns the submission.
  Future<Submission> submitEntry(EntryInput input) async {
    final result = await GetIt.instance<SubmitEntryUseCase>().call(
      listId: arg,
      input: input,
    );
    return result.fold((error) => throw error, (submission) {
      _refreshBoardAndHome();
      return submission;
    });
  }

  /// Joins this (public) board so the caller can submit.
  Future<void> join() async {
    final result = await GetIt.instance<ListsRepository>().joinList(arg);
    result.fold((error) => throw error, (_) => _refreshBoardAndHome());
  }

  /// Leaves this board; the caller's entry goes with it.
  Future<void> leave() async {
    final result = await GetIt.instance<ListsRepository>().leaveList(arg);
    result.fold((error) => throw error, (_) => _refreshBoardAndHome());
  }

  /// Deletes the caller's own entry (allowed for any member).
  Future<void> deleteMyEntry() async {
    final result = await GetIt.instance<EntriesRepository>().deleteMyEntry(arg);
    result.fold((error) => throw error, (_) => _refreshBoardAndHome());
  }

  /// Saves a text board's order, best first.
  Future<void> reorderEntries(List<String> orderedEntryIds) async {
    final result = await GetIt.instance<ListsRepository>().reorderEntries(
      listId: arg,
      orderedEntryIds: orderedEntryIds,
    );
    result.fold((error) => throw error, (_) => _refreshBoardAndHome());
  }

  /// Membership, ranks and podiums shown on Home all derive from this
  /// board, so both are refetched after a write.
  void _refreshBoardAndHome() {
    ref.invalidateSelf();
    ref.invalidate(listsProvider);
  }

  /// See [ListsRepository.updateList]: null = unchanged, "" = clear.
  Future<void> updateList({
    String? title,
    String? description,
    bool? isPublic,
    bool? locked,
    String? category,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  }) async {
    final repo = GetIt.instance<ListsRepository>();
    final result = await repo.updateList(
      listId: arg,
      title: title,
      description: description,
      isPublic: isPublic,
      locked: locked,
      category: category,
      telegramLink: telegramLink,
      whatsappLink: whatsappLink,
      discordLink: discordLink,
    );
    result.fold(
      (error) => throw error,
      (_) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteEntry(String entryId) async {
    final repo = GetIt.instance<ListsRepository>();
    final result = await repo.deleteEntry(listId: arg, entryId: entryId);
    result.fold((error) => throw error, (_) => _refreshBoardAndHome());
  }

  Future<String> getInviteLink() async {
    final repo = GetIt.instance<ListsRepository>();
    final result = await repo.getInviteLink(arg);
    return result.fold(
      (error) => throw error,
      (link) => link,
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

  Future<void> join() async {
    final result = await GetIt.instance<JoinByInviteUseCase>().call(arg);
    result.fold((error) => throw error, (_) => ref.invalidate(listsProvider));
  }
}

// --- Review queue (owner / admin / moderator) ---

final pendingSubmissionsProvider = AsyncNotifierProvider.family<
    PendingSubmissionsNotifier, List<Submission>, String>(
    PendingSubmissionsNotifier.new);

class PendingSubmissionsNotifier
    extends FamilyAsyncNotifier<List<Submission>, String> {
  @override
  Future<List<Submission>> build(String arg) async {
    final result =
        await GetIt.instance<GetPendingSubmissionsUseCase>().call(arg);
    return result.fold((error) => throw error, (queue) => queue);
  }

  /// Puts the submission on the board.
  Future<void> approve(String submissionId) async {
    final result = await GetIt.instance<ApproveSubmissionUseCase>().call(
      listId: arg,
      submissionId: submissionId,
    );
    result.fold((error) => throw error, (_) => _refresh());
  }

  Future<void> reject(String submissionId) async {
    final result = await GetIt.instance<RejectSubmissionUseCase>().call(
      listId: arg,
      submissionId: submissionId,
    );
    result.fold((error) => throw error, (_) => _refresh());
  }

  /// The queue, the board and Home's pending counts all change.
  void _refresh() {
    ref.invalidateSelf();
    ref.invalidate(listDetailProvider(arg));
    ref.invalidate(listsProvider);
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
