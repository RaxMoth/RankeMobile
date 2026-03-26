import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/colors.dart';
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

class _DetailContent extends ConsumerWidget {
  final RankedList list;
  final String listId;

  const _DetailContent({required this.list, required this.listId});

  bool get _isAdmin =>
      list.currentUserRole == MemberRole.owner ||
      list.currentUserRole == MemberRole.admin;

  bool get _hasCommsLinks =>
      list.telegramLink != null ||
      list.whatsappLink != null ||
      list.discordLink != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarks.contains(listId);

    return Column(
      children: [
        _DetailHeader(
          title: list.title.toUpperCase(),
          subtitle:
              '${list.valueType.name.toUpperCase()}  \u2022  ${list.memberCount} MEMBERS',
          onBack: () => context.pop(),
          trailing: GestureDetector(
            onTap: () =>
                ref.read(bookmarkProvider.notifier).toggle(listId),
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.accent : AppColors.textTertiary,
              size: 24,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              if (list.description != null && list.description!.isNotEmpty)
                _ObjectiveSection(description: list.description!),
              // Communication links
              if (_hasCommsLinks)
                _CommsSection(
                  telegramLink: list.telegramLink,
                  whatsappLink: list.whatsappLink,
                  discordLink: list.discordLink,
                ),
              _MetricsBar(
                valueType: list.valueType,
                entryCount: list.entries.length,
                memberCount: list.memberCount,
                locked: list.locked,
              ),
              // Admin action bar
              if (_isAdmin) _AdminActionBar(list: list, listId: listId),
              const _StandingsHeader(),
              // Standings from real data
              if (_isAdmin)
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
                  (entry) => _isAdmin
                      ? Dismissible(
                          key: ValueKey(entry.id),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) async {
                            _confirmRemoveEntry(context, ref, entry);
                            return false; // dialog handles the actual delete
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
              const SizedBox(height: 20),
              // Board analytics for admins
              if (_isAdmin)
                _AnalyticsSection(
                  memberCount: list.memberCount,
                  entryCount: list.entries.length,
                  lastSubmission: list.entries.isNotEmpty
                      ? list.entries.first.submittedAt
                      : null,
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        if (!list.locked)
          _SubmitButton(
            onPressed: () => _openSubmitSheet(context, list),
          ),
      ],
    );
  }

  void _openSubmitSheet(BuildContext context, RankedList list) {
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
      padding: const EdgeInsets.fromLTRB(4, 8, 20, 16),
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

// ─── Objective Section ────────────────────────────────────────

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

// ─── Communication Links ──────────────────────────────────────

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
            const Spacer(),
            Text(
              link.length > 30 ? '${link.substring(0, 30)}...' : link,
              style: AppTextStyles.badge
                  .copyWith(color: AppColors.textTertiary),
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

// ─── Metrics Bar ──────────────────────────────────────────────

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

// ─── Admin Action Bar ─────────────────────────────────────────

class _AdminActionBar extends ConsumerWidget {
  final RankedList list;
  final String listId;

  const _AdminActionBar({required this.list, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accent.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined,
                  color: AppColors.accent, size: 16),
              const SizedBox(width: 8),
              Text('MODERATOR TOOLS',
                  style: AppTextStyles.badge.copyWith(color: AppColors.accent)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _AdminChip(
                icon: Icons.edit_outlined,
                label: 'EDIT',
                onTap: () => _openEditSheet(context, list),
              ),
              _AdminChip(
                icon: list.locked ? Icons.lock_open : Icons.lock_outline,
                label: list.locked ? 'UNLOCK' : 'LOCK',
                onTap: () async {
                  await ref
                      .read(listDetailProvider(listId).notifier)
                      .updateList(locked: !list.locked);
                },
              ),
              _AdminChip(
                icon: Icons.people_outline,
                label: 'MEMBERS',
                onTap: () => context.push('/lists/$listId/members'),
              ),
              _AdminChip(
                icon: Icons.share_outlined,
                label: 'INVITE',
                onTap: () => _shareInvite(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openEditSheet(BuildContext context, RankedList list) {
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

class _AdminChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AdminChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.badge
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Standings ────────────────────────────────────────────────

class _StandingsHeader extends StatelessWidget {
  const _StandingsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('OFFICIAL STANDINGS', style: AppTextStyles.sectionHeader),
        ],
      ),
    );
  }
}

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
              width: 48,
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
              width: 40,
              height: 40,
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
            Text(
              _formatValue(entry),
              style: AppTextStyles.statValue.copyWith(
                color:
                    isCurrentUser ? AppColors.accent : AppColors.textPrimary,
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
