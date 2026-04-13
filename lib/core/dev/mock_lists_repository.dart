import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../features/lists/domain/entities/ranked_list.dart';
import '../../features/lists/domain/lists_repository.dart';
import '../../features/profile/domain/entities/user_profile.dart';
import '../network/api_error.dart';
import 'dev_config.dart';

const _uuid = Uuid();
const _currentUserId = 'dev-user-001';

/// Category constants used for seed data and Discover filtering.
class BoardCategory {
  static const finance = 'FINANCE';
  static const fitness = 'FITNESS';
  static const coding = 'CODING';
  static const health = 'HEALTH';
  static const gaming = 'GAMING';
  static const education = 'EDUCATION';

  static const all = [finance, fitness, coding, health, gaming, education];
}

/// Mock lists repository with in-memory state for dev mode.
/// Supports full CRUD — data persists for the lifetime of the app.
class MockListsRepository implements ListsRepository {
  final Map<String, _MockListData> _lists = {};
  final Map<String, List<ListMember>> _members = {};
  final Map<String, String> _categories = {}; // listId → category

  MockListsRepository() {
    _seedData();
  }

  void _seedData() {
    // ── Board 1: Finance (owned, with comms) ──
    final financeId = _uuid.v4();
    _lists[financeId] = _MockListData(
      list: RankedList(
        id: financeId,
        title: 'YTD Equity Returns',
        description:
            'Track total realized and unrealized equity gains from Jan 1st to Dec 31st. Percentage-based reporting only.',
        valueType: ValueType.number,
        rankOrder: RankOrder.desc,
        isPublic: true,
        locked: false,
        inviteToken: 'inv-finance-001',
        telegramLink: 'https://t.me/ytdreturns',
        discordLink: 'https://discord.gg/equityclub',
        entries: [
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-nakamura',
            displayName: 'K. Nakamura',
            rank: 1,
            valueNumber: 48.2,
            submittedAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-chen',
            displayName: 'S. Chen',
            rank: 2,
            valueNumber: 36.5,
            submittedAt: DateTime.now().subtract(const Duration(hours: 8)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-petrov',
            displayName: 'V. Petrov',
            rank: 3,
            valueNumber: 34.1,
            submittedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: _currentUserId,
            displayName: 'Max Roth',
            rank: 4,
            valueNumber: 14.2,
            note: 'Mostly index funds',
            submittedAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-kim',
            displayName: 'J. Kim',
            rank: 5,
            valueNumber: 12.8,
            submittedAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ],
        memberCount: 12402,
        currentUserRole: MemberRole.owner,
      ),
    );
    _categories[financeId] = BoardCategory.finance;
    _members[financeId] = [
      const ListMember(
          userId: _currentUserId,
          displayName: 'Max Roth',
          role: MemberRole.owner),
      const ListMember(
          userId: 'user-nakamura',
          displayName: 'K. Nakamura',
          role: MemberRole.admin),
      const ListMember(
          userId: 'user-chen',
          displayName: 'S. Chen',
          role: MemberRole.member),
      const ListMember(
          userId: 'user-petrov',
          displayName: 'V. Petrov',
          role: MemberRole.member),
      const ListMember(
          userId: 'user-kim',
          displayName: 'J. Kim',
          role: MemberRole.member),
    ];

    // ── Board 2: Fitness / duration (member, with comms) ──
    final fitnessId = _uuid.v4();
    _lists[fitnessId] = _MockListData(
      list: RankedList(
        id: fitnessId,
        title: '5K Run Time',
        description: 'Best 5K run time. GPS-verified submissions only.',
        valueType: ValueType.duration,
        rankOrder: RankOrder.asc,
        isPublic: true,
        locked: false,
        inviteToken: 'inv-fitness-001',
        discordLink: 'https://discord.gg/5krunners',
        whatsappLink: 'https://wa.me/group/5krunners',
        entries: [
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-bolt',
            displayName: 'A. Bolt',
            rank: 1,
            valueDurationMs: 15 * 60 * 1000 + 23 * 1000,
            submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-runner',
            displayName: 'L. Martinez',
            rank: 2,
            valueDurationMs: 17 * 60 * 1000 + 45 * 1000,
            submittedAt: DateTime.now().subtract(const Duration(hours: 12)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: _currentUserId,
            displayName: 'Max Roth',
            rank: 3,
            valueDurationMs: 21 * 60 * 1000 + 45 * 1000,
            note: 'Morning run, flat terrain',
            submittedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
        memberCount: 8912,
        currentUserRole: MemberRole.member,
      ),
    );
    _categories[fitnessId] = BoardCategory.fitness;
    _members[fitnessId] = [
      const ListMember(
          userId: 'user-bolt',
          displayName: 'A. Bolt',
          role: MemberRole.owner),
      const ListMember(
          userId: 'user-runner',
          displayName: 'L. Martinez',
          role: MemberRole.admin),
      const ListMember(
          userId: _currentUserId,
          displayName: 'Max Roth',
          role: MemberRole.member),
    ];

    // ── Board 3: Coding / number (admin) ──
    final codingId = _uuid.v4();
    _lists[codingId] = _MockListData(
      list: RankedList(
        id: codingId,
        title: 'LeetCode Hard Solved',
        description: 'Total number of LeetCode Hard problems solved.',
        valueType: ValueType.number,
        rankOrder: RankOrder.desc,
        isPublic: true,
        locked: false,
        inviteToken: 'inv-coding-001',
        telegramLink: 'https://t.me/leetcodegrind',
        entries: [
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-algo',
            displayName: 'T. Wang',
            rank: 1,
            valueNumber: 412,
            submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-dev',
            displayName: 'R. Singh',
            rank: 2,
            valueNumber: 387,
            submittedAt: DateTime.now().subtract(const Duration(hours: 6)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: _currentUserId,
            displayName: 'Max Roth',
            rank: 3,
            valueNumber: 156,
            submittedAt: DateTime.now().subtract(const Duration(days: 4)),
          ),
        ],
        memberCount: 4190,
        currentUserRole: MemberRole.admin,
      ),
    );
    _categories[codingId] = BoardCategory.coding;
    _members[codingId] = [
      const ListMember(
          userId: 'user-algo',
          displayName: 'T. Wang',
          role: MemberRole.owner),
      const ListMember(
          userId: _currentUserId,
          displayName: 'Max Roth',
          role: MemberRole.admin),
      const ListMember(
          userId: 'user-dev',
          displayName: 'R. Singh',
          role: MemberRole.member),
    ];

    // ── Board 4: Health (NOT a member — Discover only) ──
    final healthId = _uuid.v4();
    _lists[healthId] = _MockListData(
      list: RankedList(
        id: healthId,
        title: 'Daily Steps Average',
        description:
            'Average daily steps over a 30-day rolling window. Honor system.',
        valueType: ValueType.number,
        rankOrder: RankOrder.desc,
        isPublic: true,
        locked: false,
        entries: [
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-walker',
            displayName: 'P. Johnson',
            rank: 1,
            valueNumber: 31240,
            submittedAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-hiker',
            displayName: 'M. Tanaka',
            rank: 2,
            valueNumber: 28100,
            submittedAt: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ],
        memberCount: 22041,
        currentUserRole: null,
      ),
    );
    _categories[healthId] = BoardCategory.health;
    _members[healthId] = [
      const ListMember(
          userId: 'user-walker',
          displayName: 'P. Johnson',
          role: MemberRole.owner),
      const ListMember(
          userId: 'user-hiker',
          displayName: 'M. Tanaka',
          role: MemberRole.member),
    ];

    // ── Board 5: Gaming (NOT a member — Discover only) ──
    final gamingId = _uuid.v4();
    _lists[gamingId] = _MockListData(
      list: RankedList(
        id: gamingId,
        title: 'Valorant Ranked Rating',
        description:
            'Current competitive ranked rating. Screenshot proof required.',
        valueType: ValueType.number,
        rankOrder: RankOrder.desc,
        isPublic: true,
        locked: false,
        discordLink: 'https://discord.gg/valranked',
        entries: [
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-gamer1',
            displayName: 'xViper',
            rank: 1,
            valueNumber: 892,
            submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-gamer2',
            displayName: 'Phantom',
            rank: 2,
            valueNumber: 845,
            submittedAt: DateTime.now().subtract(const Duration(hours: 7)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-gamer3',
            displayName: 'Sage.exe',
            rank: 3,
            valueNumber: 780,
            submittedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
        memberCount: 34210,
        currentUserRole: null,
      ),
    );
    _categories[gamingId] = BoardCategory.gaming;
    _members[gamingId] = [
      const ListMember(
          userId: 'user-gamer1',
          displayName: 'xViper',
          role: MemberRole.owner),
      const ListMember(
          userId: 'user-gamer2',
          displayName: 'Phantom',
          role: MemberRole.member),
      const ListMember(
          userId: 'user-gamer3',
          displayName: 'Sage.exe',
          role: MemberRole.member),
    ];

    // ── Board 6: Education (NOT a member — Discover only) ──
    final eduId = _uuid.v4();
    _lists[eduId] = _MockListData(
      list: RankedList(
        id: eduId,
        title: 'Books Read This Year',
        description: 'Total books completed in 2026. Audiobooks count.',
        valueType: ValueType.number,
        rankOrder: RankOrder.desc,
        isPublic: true,
        locked: false,
        telegramLink: 'https://t.me/bookworms2026',
        entries: [
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-reader1',
            displayName: 'A. Nguyen',
            rank: 1,
            valueNumber: 24,
            submittedAt: DateTime.now().subtract(const Duration(hours: 6)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-reader2',
            displayName: 'E. Hoffman',
            rank: 2,
            valueNumber: 19,
            submittedAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
        memberCount: 5621,
        currentUserRole: null,
      ),
    );
    _categories[eduId] = BoardCategory.education;
    _members[eduId] = [
      const ListMember(
          userId: 'user-reader1',
          displayName: 'A. Nguyen',
          role: MemberRole.owner),
      const ListMember(
          userId: 'user-reader2',
          displayName: 'E. Hoffman',
          role: MemberRole.member),
    ];

    // ── Board 7: Fitness/duration (NOT a member — Discover only) ──
    final marathonId = _uuid.v4();
    _lists[marathonId] = _MockListData(
      list: RankedList(
        id: marathonId,
        title: 'Marathon PR',
        description: 'Personal record marathon time. Must be a verified race.',
        valueType: ValueType.duration,
        rankOrder: RankOrder.asc,
        isPublic: true,
        locked: false,
        entries: [
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-marathoner1',
            displayName: 'E. Kipchoge Jr.',
            rank: 1,
            valueDurationMs: 2 * 3600 * 1000 + 8 * 60 * 1000 + 12 * 1000,
            submittedAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          RankedEntry(
            id: _uuid.v4(),
            userId: 'user-marathoner2',
            displayName: 'R. Dibaba',
            rank: 2,
            valueDurationMs: 2 * 3600 * 1000 + 21 * 60 * 1000 + 45 * 1000,
            submittedAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ],
        memberCount: 15780,
        currentUserRole: null,
      ),
    );
    _categories[marathonId] = BoardCategory.fitness;
    _members[marathonId] = [
      const ListMember(
          userId: 'user-marathoner1',
          displayName: 'E. Kipchoge Jr.',
          role: MemberRole.owner),
    ];
  }

  // ─── Read Operations ────────────────────────────────────────

  @override
  Future<Either<ApiError, List<ListSummary>>> getLists() async {
    await Future.delayed(DevConfig.networkDelay);
    final summaries = _lists.entries.map((entry) {
      final list = entry.value.list;
      int? ownRank;
      for (final e in list.entries) {
        if (e.userId == _currentUserId) {
          ownRank = e.rank;
          break;
        }
      }
      return ListSummary(
        id: list.id,
        title: list.title,
        valueType: list.valueType,
        rankOrder: list.rankOrder,
        isPublic: list.isPublic,
        memberCount: list.memberCount,
        ownRank: ownRank,
        currentUserRole: list.currentUserRole,
        category: _categories[list.id],
      );
    }).toList();
    return Right(summaries);
  }

  @override
  Future<Either<ApiError, RankedList>> getListDetail(String listId) async {
    await Future.delayed(DevConfig.networkDelay);
    final data = _lists[listId];
    if (data == null) {
      return const Left(ApiServerError(
          code: 'NOT_FOUND', message: 'Board not found', statusCode: 404));
    }
    return Right(data.list);
  }

  @override
  Future<Either<ApiError, List<ListSummary>>> searchPublicLists({
    String? query,
    String? category,
  }) async {
    await Future.delayed(DevConfig.networkDelay);
    final results = <ListSummary>[];

    for (final entry in _lists.entries) {
      final list = entry.value.list;
      if (!list.isPublic) continue;

      // Category filter
      if (category != null && _categories[list.id] != category) continue;

      // Query filter
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchesTitle = list.title.toLowerCase().contains(q);
        final matchesDesc =
            list.description?.toLowerCase().contains(q) ?? false;
        if (!matchesTitle && !matchesDesc) continue;
      }

      int? ownRank;
      for (final e in list.entries) {
        if (e.userId == _currentUserId) {
          ownRank = e.rank;
          break;
        }
      }

      results.add(ListSummary(
        id: list.id,
        title: list.title,
        valueType: list.valueType,
        rankOrder: list.rankOrder,
        isPublic: list.isPublic,
        memberCount: list.memberCount,
        ownRank: ownRank,
        currentUserRole: list.currentUserRole,
        category: _categories[list.id],
      ));
    }

    return Right(results);
  }

  // ─── Create / Update / Delete ───────────────────────────────

  @override
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
  }) async {
    await Future.delayed(DevConfig.networkDelay);
    final id = _uuid.v4();
    final newList = RankedList(
      id: id,
      title: title,
      description: description,
      valueType: valueType,
      rankOrder: rankOrder,
      isPublic: isPublic,
      locked: false,
      inviteToken: 'inv-${id.substring(0, 8)}',
      entries: [],
      memberCount: 1,
      currentUserRole: MemberRole.owner,
      telegramLink: telegramLink,
      whatsappLink: whatsappLink,
      discordLink: discordLink,
    );
    _lists[id] = _MockListData(list: newList);
    if (category != null) _categories[id] = category;
    _members[id] = [
      const ListMember(
          userId: _currentUserId,
          displayName: 'Max Roth',
          role: MemberRole.owner),
    ];
    return Right(newList);
  }

  @override
  Future<Either<ApiError, RankedList>> updateList({
    required String listId,
    String? title,
    String? description,
    bool? isPublic,
    bool? locked,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  }) async {
    await Future.delayed(DevConfig.networkDelay);
    final data = _lists[listId];
    if (data == null) {
      return const Left(ApiServerError(
          code: 'NOT_FOUND', message: 'Board not found', statusCode: 404));
    }
    final updated = data.list.copyWith(
      title: title ?? data.list.title,
      description: description ?? data.list.description,
      isPublic: isPublic ?? data.list.isPublic,
      locked: locked ?? data.list.locked,
      telegramLink: telegramLink ?? data.list.telegramLink,
      whatsappLink: whatsappLink ?? data.list.whatsappLink,
      discordLink: discordLink ?? data.list.discordLink,
    );
    _lists[listId] = _MockListData(list: updated);
    return Right(updated);
  }

  @override
  Future<Either<ApiError, void>> deleteList(String listId) async {
    await Future.delayed(DevConfig.networkDelay);
    _lists.remove(listId);
    _members.remove(listId);
    _categories.remove(listId);
    return const Right(null);
  }

  @override
  Future<Either<ApiError, void>> deleteEntry({
    required String listId,
    required String entryId,
  }) async {
    await Future.delayed(DevConfig.networkDelay);
    final data = _lists[listId];
    if (data == null) return const Right(null);
    final updatedEntries =
        data.list.entries.where((e) => e.id != entryId).toList();
    for (int i = 0; i < updatedEntries.length; i++) {
      updatedEntries[i] = updatedEntries[i].copyWith(rank: i + 1);
    }
    _lists[listId] = _MockListData(
      list: data.list.copyWith(entries: updatedEntries),
    );
    return const Right(null);
  }

  // ─── Invite Operations ──────────────────────────────────────

  @override
  Future<Either<ApiError, RankedList>> getInvitePreview(String token) async {
    await Future.delayed(DevConfig.networkDelay);
    for (final data in _lists.values) {
      if (data.list.inviteToken == token) {
        return Right(data.list);
      }
    }
    return const Left(ApiServerError(
        code: 'INVALID_TOKEN', message: 'Invite not found', statusCode: 404));
  }

  @override
  Future<Either<ApiError, void>> joinByInvite(String token) async {
    await Future.delayed(DevConfig.networkDelay);
    return const Right(null);
  }

  @override
  Future<Either<ApiError, String>> getInviteLink(String listId) async {
    await Future.delayed(DevConfig.networkDelay);
    final data = _lists[listId];
    if (data == null) {
      return const Left(ApiServerError(
          code: 'NOT_FOUND', message: 'Board not found', statusCode: 404));
    }
    return Right(data.list.inviteToken ?? 'inv-${listId.substring(0, 8)}');
  }

  @override
  Future<Either<ApiError, String>> regenerateInvite(String listId) async {
    await Future.delayed(DevConfig.networkDelay);
    final newToken = 'inv-${_uuid.v4().substring(0, 8)}';
    final data = _lists[listId];
    if (data != null) {
      _lists[listId] = _MockListData(
        list: data.list.copyWith(inviteToken: newToken),
      );
    }
    return Right(newToken);
  }

  // ─── Member Operations ──────────────────────────────────────

  @override
  Future<Either<ApiError, List<ListMember>>> getMembers(String listId) async {
    await Future.delayed(DevConfig.networkDelay);
    return Right(_members[listId] ?? []);
  }

  @override
  Future<Either<ApiError, void>> updateMemberRole({
    required String listId,
    required String userId,
    required MemberRole role,
  }) async {
    await Future.delayed(DevConfig.networkDelay);
    final members = _members[listId];
    if (members != null) {
      final idx = members.indexWhere((m) => m.userId == userId);
      if (idx != -1) {
        members[idx] = ListMember(
          userId: userId,
          displayName: members[idx].displayName,
          role: role,
        );
      }
    }
    return const Right(null);
  }

  @override
  Future<Either<ApiError, void>> removeMember({
    required String listId,
    required String userId,
  }) async {
    await Future.delayed(DevConfig.networkDelay);
    _members[listId]?.removeWhere((m) => m.userId == userId);
    final data = _lists[listId];
    if (data != null) {
      _lists[listId] = _MockListData(
        list: data.list.copyWith(
          entries: data.list.entries.where((e) => e.userId != userId).toList(),
          memberCount: data.list.memberCount - 1,
        ),
      );
    }
    return const Right(null);
  }

  @override
  Future<Either<ApiError, UserProfile>> getUserProfile(String userId) async {
    await Future.delayed(DevConfig.networkDelay);

    // Find display name from any member list or entry
    String? displayName;
    final userBoards = <ListSummary>[];

    for (final entry in _lists.entries) {
      final data = entry.value;
      final listId = entry.key;

      // Check members
      final members = _members[listId] ?? [];
      final memberMatch = members.where((m) => m.userId == userId);
      if (memberMatch.isNotEmpty) {
        displayName ??= memberMatch.first.displayName;
      }

      // Check entries
      final entryMatch = data.list.entries.where((e) => e.userId == userId);
      if (entryMatch.isNotEmpty) {
        displayName ??= entryMatch.first.displayName;
      }

      // If user is a member, add this board to their profile
      if (memberMatch.isNotEmpty || entryMatch.isNotEmpty) {
        final ownRank = entryMatch.isNotEmpty ? entryMatch.first.rank : null;
        userBoards.add(ListSummary(
          id: listId,
          title: data.list.title,
          valueType: data.list.valueType,
          rankOrder: data.list.rankOrder,
          isPublic: data.list.isPublic,
          memberCount: data.list.memberCount,
          ownRank: ownRank,
          currentUserRole: memberMatch.isNotEmpty ? memberMatch.first.role : null,
          category: _categories[listId],
        ));
      }
    }

    if (displayName == null) {
      return const Left(ApiServerError(
        code: 'NOT_FOUND',
        message: 'User not found',
        statusCode: 404,
      ));
    }

    return Right(UserProfile(
      userId: userId,
      displayName: displayName,
      memberSince: DateTime.now().subtract(const Duration(days: 120)),
      boards: userBoards,
    ));
  }

  /// Exposed for [MockEntriesRepository] to update entries after submission.
  void updateEntries(String listId, List<RankedEntry> entries) {
    final data = _lists[listId];
    if (data != null) {
      _lists[listId] = _MockListData(
        list: data.list.copyWith(entries: entries),
      );
    }
  }
}

/// Internal wrapper for mutable list state.
class _MockListData {
  RankedList list;
  _MockListData({required this.list});
}
