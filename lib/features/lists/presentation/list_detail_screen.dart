import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/theme/text_styles.dart';
import '../domain/entities/ranked_list.dart';
import '../../entries/presentation/submit_entry_sheet.dart';
import '../../entries/presentation/widgets/duration_picker.dart';
import 'edit_board_sheet.dart';
import 'providers/bookmark_provider.dart';
import 'providers/lists_provider.dart';

/// List Detail Screen — full ranked leaderboard with standings
class ListDetailScreen extends ConsumerWidget {
  final String listId;

  const ListDetailScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(listDetailProvider(listId));

    return Scaffold(
      body: SafeArea(
        child: detailAsync.when(
          data: (list) => _DetailContent(list: list, listId: listId),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.error, size: 32),
                const SizedBox(height: 12),
                Text(
                  'FAILED TO LOAD BOARD',
                  style: AppTextStyles.sectionHeader
                      .copyWith(color: AppColors.error),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('GO BACK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Tab Definition ──────────────────────────────────────────

class _TabDef {
  final String label;
  final _TabType type;
  const _TabDef(this.label, this.type);
}

enum _TabType { standings, info, comms, stats, admin }

// ─── Detail Content (Tabbed) ─────────────────────────────────

class _DetailContent extends ConsumerStatefulWidget {
  final RankedList list;
  final String listId;

  const _DetailContent({required this.list, required this.listId});

  @override
  ConsumerState<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends ConsumerState<_DetailContent>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<_TabDef> _tabs;

  bool get _isAdmin =>
      widget.list.currentUserRole == MemberRole.owner ||
      widget.list.currentUserRole == MemberRole.admin;

  bool get _hasCommsLinks =>
      widget.list.telegramLink != null ||
      widget.list.whatsappLink != null ||
      widget.list.discordLink != null;

  List<_TabDef> _buildTabs() {
    final tabs = <_TabDef>[
      const _TabDef('STANDINGS', _TabType.standings),
      const _TabDef('INFO', _TabType.info),
    ];
    if (_hasCommsLinks) {
      tabs.add(const _TabDef('COMMS', _TabType.comms));
    }
    tabs.add(const _TabDef('STATS', _TabType.stats));
    if (_isAdmin) {
      tabs.add(const _TabDef('ADMIN', _TabType.admin));
    }
    return tabs;
  }

  @override
  void initState() {
    super.initState();
    _tabs = _buildTabs();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void didUpdateWidget(covariant _DetailContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTabs = _buildTabs();
    if (newTabs.length != _tabs.length) {
      final oldIndex = _tabController.index;
      _tabController.dispose();
      _tabs = newTabs;
      _tabController = TabController(
        length: _tabs.length,
        vsync: this,
        initialIndex: oldIndex.clamp(0, _tabs.length - 1),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarks.contains(widget.listId);

    return Column(
      children: [
        _DetailHeader(
          title: widget.list.title.toUpperCase(),
          subtitle:
              '${widget.list.valueType.name.toUpperCase()}  \u2022  ${widget.list.memberCount} MEMBERS',
          onBack: () => context.pop(),
          trailing: GestureDetector(
            onTap: () =>
                ref.read(bookmarkProvider.notifier).toggle(widget.listId),
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.accent : AppColors.textTertiary,
              size: 24,
            ),
          ),
        ),
        // Tab bar
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: AppTextStyles.tab,
            unselectedLabelStyle: AppTextStyles.tab,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.accent,
            indicatorWeight: 2.0,
            dividerColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
          ),
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabs.map((t) => _buildTabContent(t.type)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(_TabType type) {
    return switch (type) {
      _TabType.standings => _StandingsTab(
          list: widget.list,
          listId: widget.listId,
          isAdmin: _isAdmin,
        ),
      _TabType.info => _InfoTab(list: widget.list),
      _TabType.comms => _CommsTab(list: widget.list, isAdmin: _isAdmin),
      _TabType.stats => _StatsTab(list: widget.list),
      _TabType.admin => _AdminTab(list: widget.list, listId: widget.listId),
    };
  }
}

// ─── Detail Header ────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final Widget? trailing;

  const _DetailHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 20, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left,
                color: AppColors.textPrimary, size: 28),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.screenTitle),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.subtitle),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─── STANDINGS TAB ───────────────────────────────────────────

class _StandingsTab extends ConsumerWidget {
  final RankedList list;
  final String listId;
  final bool isAdmin;

  const _StandingsTab({
    required this.list,
    required this.listId,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            children: [
              if (isAdmin)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'SWIPE LEFT TO REMOVE ENTRIES',
                    style: AppTextStyles.badge
                        .copyWith(color: AppColors.textTertiary, fontSize: 9),
                  ),
                ),
              if (list.entries.isEmpty)
                _EmptyStandings()
              else
                ...list.entries.map(
                  (entry) => isAdmin
                      ? Dismissible(
                          key: ValueKey(entry.id),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) async {
                            _confirmRemoveEntry(context, ref, entry);
                            return false;
                          },
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete_outline,
                                color: Colors.white, size: 22),
                          ),
                          child: _StandingRow(
                            entry: entry,
                            valueType: list.valueType,
                            isAdmin: true,
                            onRemove: () =>
                                _confirmRemoveEntry(context, ref, entry),
                          ),
                        )
                      : _StandingRow(
                          entry: entry,
                          valueType: list.valueType,
                        ),
                ),
            ],
          ),
        ),
        if (!list.locked)
          _SubmitButton(
            onPressed: () => _openSubmitSheet(context),
          ),
      ],
    );
  }

  void _openSubmitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SubmitEntrySheet(
        listId: listId,
        valueType: list.valueType,
        telegramLink: list.telegramLink,
        whatsappLink: list.whatsappLink,
        discordLink: list.discordLink,
      ),
    );
  }

  void _confirmRemoveEntry(
      BuildContext context, WidgetRef ref, RankedEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('REMOVE ENTRY', style: AppTextStyles.screenTitle),
            const SizedBox(height: 12),
            Text(
              'Remove ${entry.displayName}\'s entry from this board?',
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: Text('CANCEL',
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await ref
                          .read(listDetailProvider(listId).notifier)
                          .deleteEntry(entry.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    child: const Text('REMOVE'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─── INFO TAB ────────────────────────────────────────────────

class _InfoTab extends StatelessWidget {
  final RankedList list;

  const _InfoTab({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        if (list.description != null && list.description!.isNotEmpty)
          _ObjectiveSection(description: list.description!),
        _MetricsBar(
          valueType: list.valueType,
          entryCount: list.entries.length,
          memberCount: list.memberCount,
          locked: list.locked,
        ),
        // Board details
        _InfoCard(
          children: [
            _InfoRow(
              label: 'RANK ORDER',
              value: list.rankOrder == RankOrder.desc
                  ? 'HIGHEST WINS'
                  : 'LOWEST WINS',
              icon: list.rankOrder == RankOrder.desc
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'VISIBILITY',
              value: list.isPublic ? 'PUBLIC' : 'PRIVATE',
              icon: list.isPublic ? Icons.public : Icons.lock_outline,
            ),
            if (list.locked) ...[
              const SizedBox(height: 12),
              _InfoRow(
                label: 'STATUS',
                value: 'LOCKED — NO NEW ENTRIES',
                icon: Icons.lock,
                valueColor: AppColors.warning,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BOARD DETAILS', style: AppTextStyles.label),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textTertiary, size: 16),
        const SizedBox(width: 10),
        Text(label,
            style:
                AppTextStyles.badge.copyWith(color: AppColors.textTertiary)),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.badge.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// ─── COMMS TAB ───────────────────────────────────────────────

class _CommsTab extends StatelessWidget {
  final RankedList list;
  final bool isAdmin;

  const _CommsTab({required this.list, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        _CommsSection(
          telegramLink: list.telegramLink,
          whatsappLink: list.whatsappLink,
          discordLink: list.discordLink,
        ),
      ],
    );
  }
}

// ─── STATS TAB ───────────────────────────────────────────────

class _StatsTab extends StatelessWidget {
  final RankedList list;

  const _StatsTab({required this.list});

  @override
  Widget build(BuildContext context) {
    final entries = list.entries;
    final lastSubmission =
        entries.isNotEmpty ? entries.first.submittedAt : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        _AnalyticsSection(
          memberCount: list.memberCount,
          entryCount: entries.length,
          lastSubmission: lastSubmission,
        ),
        const SizedBox(height: 16),
        // Recent activity
        if (entries.isNotEmpty) ...[
          _RecentActivitySection(entries: entries),
        ],
      ],
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  final List<RankedEntry> entries;

  const _RecentActivitySection({required this.entries});

  @override
  Widget build(BuildContext context) {
    final sorted = [...entries]
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    final recent = sorted.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RECENT ACTIVITY', style: AppTextStyles.label),
          const SizedBox(height: 12),
          ...recent.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          entry.displayName.isNotEmpty
                              ? entry.displayName[0].toUpperCase()
                              : '?',
                          style: AppTextStyles.badge
                              .copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${entry.displayName.toUpperCase()} — RANK ${entry.rank}',
                        style: AppTextStyles.badge
                            .copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _relativeTime(entry.submittedAt),
                      style: AppTextStyles.badge
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}D AGO';
    if (diff.inHours > 0) return '${diff.inHours}H AGO';
    if (diff.inMinutes > 0) return '${diff.inMinutes}M AGO';
    return 'JUST NOW';
  }
}

// ─── ADMIN TAB ───────────────────────────────────────────────

class _AdminTab extends ConsumerWidget {
  final RankedList list;
  final String listId;

  const _AdminTab({required this.list, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingEntriesProvider(listId));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        // Pending submissions section
        pendingAsync.when(
          data: (pending) => pending.isEmpty
              ? const SizedBox.shrink()
              : _PendingSubmissionsSection(
                  entries: pending,
                  listId: listId,
                  valueType: list.valueType,
                ),
          loading: () => Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: AppColors.accent, strokeWidth: 2),
              ),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
        // Admin actions
        _AdminActionCard(
          icon: Icons.edit_outlined,
          title: 'EDIT BOARD',
          subtitle: 'MODIFY TITLE, DESCRIPTION, LINKS',
          onTap: () => _openEditSheet(context),
        ),
        const SizedBox(height: 8),
        _AdminActionCard(
          icon: list.locked ? Icons.lock_open : Icons.lock_outline,
          title: list.locked ? 'UNLOCK BOARD' : 'LOCK BOARD',
          subtitle: list.locked
              ? 'ALLOW NEW ENTRY SUBMISSIONS'
              : 'PREVENT NEW ENTRY SUBMISSIONS',
          onTap: () async {
            await ref
                .read(listDetailProvider(listId).notifier)
                .updateList(locked: !list.locked);
          },
        ),
        const SizedBox(height: 8),
        _AdminActionCard(
          icon: Icons.people_outline,
          title: 'MANAGE MEMBERS',
          subtitle: '${list.memberCount} MEMBERS — ROLES & ACCESS',
          onTap: () => context.push('/lists/$listId/members'),
        ),
        const SizedBox(height: 8),
        _AdminActionCard(
          icon: Icons.share_outlined,
          title: 'SHARE INVITE',
          subtitle: 'GENERATE INVITE LINK',
          onTap: () => _shareInvite(context, ref),
        ),
      ],
    );
  }

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => EditBoardSheet(listId: listId, list: list),
    );
  }

  Future<void> _shareInvite(BuildContext context, WidgetRef ref) async {
    try {
      final link = await ref
          .read(listDetailProvider(listId).notifier)
          .getInviteLink();
      await Share.share('Join my board on Apex: rankapp://invite/$link');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('FAILED TO GET INVITE: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _AdminActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accent.withAlpha(10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.accent.withAlpha(40)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.badge
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Pending Submissions ─────────────────────────────────────

class _PendingSubmissionsSection extends ConsumerWidget {
  final List<RankedEntry> entries;
  final String listId;
  final ValueType valueType;

  const _PendingSubmissionsSection({
    required this.entries,
    required this.listId,
    required this.valueType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.hourglass_top,
                  color: AppColors.warning, size: 16),
              const SizedBox(width: 8),
              Text(
                'PENDING SUBMISSIONS (${entries.length})',
                style:
                    AppTextStyles.badge.copyWith(color: AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...entries.map((entry) => _PendingEntryCard(
                entry: entry,
                listId: listId,
                valueType: valueType,
              )),
        ],
      ),
    );
  }
}

class _PendingEntryCard extends ConsumerStatefulWidget {
  final RankedEntry entry;
  final String listId;
  final ValueType valueType;

  const _PendingEntryCard({
    required this.entry,
    required this.listId,
    required this.valueType,
  });

  @override
  ConsumerState<_PendingEntryCard> createState() => _PendingEntryCardState();
}

class _PendingEntryCardState extends ConsumerState<_PendingEntryCard> {
  bool _isProcessing = false;

  Future<void> _approve() async {
    setState(() => _isProcessing = true);
    try {
      await ref
          .read(pendingEntriesProvider(widget.listId).notifier)
          .approve(widget.entry.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('FAILED: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _reject() async {
    setState(() => _isProcessing = true);
    try {
      await ref
          .read(pendingEntriesProvider(widget.listId).notifier)
          .reject(widget.entry.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('FAILED: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  String _formatValue() {
    return switch (widget.valueType) {
      ValueType.number => widget.entry.valueNumber
              ?.toStringAsFixed(
                  widget.entry.valueNumber!.truncateToDouble() ==
                          widget.entry.valueNumber!
                      ? 0
                      : 1) ??
          '—',
      ValueType.duration => widget.entry.valueDurationMs != null
          ? formatDuration(widget.entry.valueDurationMs!)
          : '—',
      ValueType.text => widget.entry.valueText ?? '—',
    };
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}D AGO';
    if (diff.inHours > 0) return '${diff.inHours}H AGO';
    if (diff.inMinutes > 0) return '${diff.inMinutes}M AGO';
    return 'JUST NOW';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    widget.entry.displayName.isNotEmpty
                        ? widget.entry.displayName[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.entry.displayName.toUpperCase(),
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    if (widget.entry.note != null &&
                        widget.entry.note!.isNotEmpty)
                      Text(
                        widget.entry.note!,
                        style: AppTextStyles.badge
                            .copyWith(color: AppColors.textTertiary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_formatValue(),
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w800)),
                  Text(
                    _relativeTime(widget.entry.submittedAt),
                    style: AppTextStyles.badge
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _isProcessing ? null : _reject,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.error.withAlpha(80)),
                    ),
                    child: Center(
                      child: Text(
                        'REJECT',
                        style: AppTextStyles.badge
                            .copyWith(color: AppColors.error),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: _isProcessing ? null : _approve,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: _isProcessing
                          ? const SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: AppColors.background,
                              ),
                            )
                          : Text(
                              'APPROVE',
                              style: AppTextStyles.badge
                                  .copyWith(color: AppColors.background),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ──────────────────────────────────────────

class _ObjectiveSection extends StatelessWidget {
  final String description;

  const _ObjectiveSection({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('OBJECTIVE', style: AppTextStyles.label),
          const SizedBox(height: 8),
          Text(description, style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}

class _CommsSection extends StatelessWidget {
  final String? telegramLink;
  final String? whatsappLink;
  final String? discordLink;

  const _CommsSection({
    this.telegramLink,
    this.whatsappLink,
    this.discordLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('COMMUNITY', style: AppTextStyles.label),
          const SizedBox(height: 12),
          if (telegramLink != null)
            _CommsRow(
              icon: Icons.send,
              label: 'TELEGRAM',
              link: telegramLink!,
            ),
          if (whatsappLink != null)
            _CommsRow(
              icon: Icons.chat,
              label: 'WHATSAPP',
              link: whatsappLink!,
            ),
          if (discordLink != null)
            _CommsRow(
              icon: Icons.headphones,
              label: 'DISCORD',
              link: discordLink!,
            ),
        ],
      ),
    );
  }
}

class _CommsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String link;

  const _CommsRow({
    required this.icon,
    required this.label,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          // TODO: Use url_launcher when added
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(link),
              backgroundColor: AppColors.surface,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 16),
            const SizedBox(width: 10),
            Text(label, style: AppTextStyles.badge),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                link,
                style: AppTextStyles.badge
                    .copyWith(color: AppColors.textTertiary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.open_in_new,
                color: AppColors.textTertiary, size: 12),
          ],
        ),
      ),
    );
  }
}

class _MetricsBar extends StatelessWidget {
  final ValueType valueType;
  final int entryCount;
  final int memberCount;
  final bool locked;

  const _MetricsBar({
    required this.valueType,
    required this.entryCount,
    required this.memberCount,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VALUE TYPE',
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: 6),
                Text(
                  valueType.name.toUpperCase(),
                  style:
                      AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('ENTRIES',
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: 6),
              Text(
                '$entryCount',
                style:
                    AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          if (locked) ...[
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withAlpha(25),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, color: AppColors.warning, size: 12),
                  const SizedBox(width: 4),
                  Text('LOCKED',
                      style: AppTextStyles.badge
                          .copyWith(color: AppColors.warning)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Standing Row ────────────────────────────────────────────

class _StandingRow extends StatelessWidget {
  final RankedEntry entry;
  final ValueType valueType;
  final bool isAdmin;
  final VoidCallback? onRemove;

  const _StandingRow({
    required this.entry,
    required this.valueType,
    this.isAdmin = false,
    this.onRemove,
  });

  // TODO: compare with current user id from auth provider
  bool get isCurrentUser => false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: isAdmin ? onRemove : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? AppColors.accent.withAlpha(20)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrentUser
                ? AppColors.accent.withAlpha(80)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: Responsive.scale(context, 36),
              child: Text(
                entry.rank.toString().padLeft(2, '0'),
                style: AppTextStyles.rankNumber.copyWith(
                  color: isCurrentUser
                      ? AppColors.accent
                      : AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Avatar placeholder
            Container(
              width: Responsive.scale(context, 40),
              height: Responsive.scale(context, 40),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  entry.displayName.isNotEmpty
                      ? entry.displayName[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isCurrentUser
                        ? AppColors.accent
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.displayName.toUpperCase(),
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (entry.note != null && entry.note!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        entry.note!,
                        style: AppTextStyles.badge
                            .copyWith(color: AppColors.textTertiary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            // Value
            Flexible(
              flex: 0,
              child: Text(
                _formatValue(entry),
                style: AppTextStyles.statValue.copyWith(
                  color:
                      isCurrentUser ? AppColors.accent : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(RankedEntry entry) {
    return switch (valueType) {
      ValueType.number =>
        entry.valueNumber?.toStringAsFixed(entry.valueNumber!.truncateToDouble() == entry.valueNumber! ? 0 : 1) ??
            '—',
      ValueType.duration =>
        entry.valueDurationMs != null
            ? formatDuration(entry.valueDurationMs!)
            : '—',
      ValueType.text => entry.valueText ?? '—',
    };
  }
}

class _EmptyStandings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.leaderboard_outlined,
              color: AppColors.textTertiary, size: 32),
          const SizedBox(height: 12),
          Text('NO ENTRIES YET',
              style: AppTextStyles.sectionHeader
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('BE THE FIRST TO SUBMIT',
              style:
                  AppTextStyles.badge.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}

// ─── Analytics Section ────────────────────────────────────────

class _AnalyticsSection extends StatelessWidget {
  final int memberCount;
  final int entryCount;
  final DateTime? lastSubmission;

  const _AnalyticsSection({
    required this.memberCount,
    required this.entryCount,
    this.lastSubmission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BOARD ANALYTICS', style: AppTextStyles.label),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _AnalyticItem(
                      label: 'MEMBERS', value: memberCount.toString())),
              Expanded(
                  child: _AnalyticItem(
                      label: 'ENTRIES', value: entryCount.toString())),
              Expanded(
                child: _AnalyticItem(
                  label: 'LAST ENTRY',
                  value: lastSubmission != null
                      ? _formatRelativeTime(lastSubmission!)
                      : 'N/A',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}D AGO';
    if (diff.inHours > 0) return '${diff.inHours}H AGO';
    if (diff.inMinutes > 0) return '${diff.inMinutes}M AGO';
    return 'JUST NOW';
  }
}

class _AnalyticItem extends StatelessWidget {
  final String label;
  final String value;

  const _AnalyticItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style:
                AppTextStyles.badge.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

// ─── Submit Button ────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: const Text('SUBMIT NEW ENTRY'),
      ),
    );
  }
}
