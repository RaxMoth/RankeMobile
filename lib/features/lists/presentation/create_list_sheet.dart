import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dev/mock_lists_repository.dart';
import '../../../core/strings.dart';
import '../../../core/theme/animations.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';

/// Multi-step board creation flow.
///
/// Steps:
///   1. Type — pick ValueType (tap auto-advances)
///   2. Identity — title, description, category
///   3. Rules — rank order, public/private, execution rules
///   4. Share — optional comms channels, then preview + create
class CreateListScreen extends ConsumerStatefulWidget {
  const CreateListScreen({super.key});

  @override
  ConsumerState<CreateListScreen> createState() => _CreateListScreenState();
}

class _CreateListScreenState extends ConsumerState<CreateListScreen> {
  static const _stepCount = 4;

  final _pageController = PageController();
  final _titleController = TextEditingController();
  final _scopeController = TextEditingController();
  final _rulesController = TextEditingController();
  final _telegramController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _discordController = TextEditingController();

  int _step = 0;
  bool _isPublic = true;
  ValueType _valueType = ValueType.number;
  RankOrder _rankOrder = RankOrder.desc;
  String? _category;
  bool _isSubmitting = false;
  String? _titleError;

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _scopeController.dispose();
    _rulesController.dispose();
    _telegramController.dispose();
    _whatsappController.dispose();
    _discordController.dispose();
    super.dispose();
  }

  // ── Step navigation ────────────────────────────────────────

  void _goTo(int step) {
    if (step < 0 || step >= _stepCount) return;
    HapticFeedback.lightImpact();
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: AppAnimations.standard,
      curve: AppAnimations.curve,
    );
  }

  void _next() {
    if (_step == 1 && _titleController.text.trim().isEmpty) {
      setState(() => _titleError = S.boardIdentifierRequired);
      return;
    }
    if (_step < _stepCount - 1) {
      _goTo(_step + 1);
    }
  }

  // ── Submit ────────────────────────────────────────────────

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _goTo(1);
      setState(() => _titleError = S.boardIdentifierRequired);
      return;
    }
    setState(() {
      _titleError = null;
      _isSubmitting = true;
    });

    try {
      await ref.read(listsProvider.notifier).createList(
            title: title,
            description: _scopeController.text.trim().isEmpty
                ? null
                : _scopeController.text.trim(),
            valueType: _valueType,
            rankOrder: _rankOrder,
            isPublic: _isPublic,
            category: _category,
            telegramLink: _telegramController.text.trim().isEmpty
                ? null
                : _telegramController.text.trim(),
            whatsappLink: _whatsappController.text.trim().isEmpty
                ? null
                : _whatsappController.text.trim(),
            discordLink: _discordController.text.trim().isEmpty
                ? null
                : _discordController.text.trim(),
          );
      await HapticFeedback.mediumImpact();
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.failedToCreateBoard(e)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: back / cancel + progress dots
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _step == 0 ? () => context.pop() : () => _goTo(_step - 1),
                    icon: Icon(
                      _step == 0 ? Icons.close : Icons.chevron_left,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Center(child: _ProgressDots(step: _step, total: _stepCount)),
                  ),
                  TextButton(
                    onPressed: _isSubmitting ? null : () => context.pop(),
                    child: Text(
                      S.cancel,
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  _TypeStep(
                    value: _valueType,
                    onSelected: (t) {
                      setState(() {
                        _valueType = t;
                        if (t == ValueType.text) _rankOrder = RankOrder.asc;
                      });
                      // Auto-advance after a short beat so the selection can be seen
                      Future<void>.delayed(AppAnimations.short, () {
                        if (mounted) _goTo(1);
                      });
                    },
                  ),
                  _IdentityStep(
                    titleController: _titleController,
                    scopeController: _scopeController,
                    category: _category,
                    onCategoryChanged: (c) => setState(() => _category = c),
                    titleError: _titleError,
                    onTitleChanged: () {
                      if (_titleError != null) setState(() => _titleError = null);
                    },
                  ),
                  _RulesStep(
                    valueType: _valueType,
                    rankOrder: _rankOrder,
                    onRankOrderChanged: (o) => setState(() => _rankOrder = o),
                    isPublic: _isPublic,
                    onPublicChanged: (v) => setState(() => _isPublic = v),
                    rulesController: _rulesController,
                  ),
                  _ShareStep(
                    telegramController: _telegramController,
                    whatsappController: _whatsappController,
                    discordController: _discordController,
                    title: _titleController.text.trim(),
                    valueType: _valueType,
                    rankOrder: _rankOrder,
                    isPublic: _isPublic,
                    category: _category,
                    scope: _scopeController.text.trim(),
                  ),
                ],
              ),
            ),
            // Bottom nav
            Padding(
              padding: EdgeInsets.fromLTRB(
                20, 8, 20, 16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting ? null : () => _goTo(_step - 1),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          S.back,
                          style: AppTextStyles.button
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : (_step == _stepCount - 1 ? _submit : _next),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.background,
                              ),
                            )
                          : Text(
                              _step == _stepCount - 1 ? S.create : S.next,
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.background,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══ Shared step widgets ══════════════════════════════════════════

class _ProgressDots extends StatelessWidget {
  final int step;
  final int total;
  const _ProgressDots({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < total; i++) ...[
          AnimatedContainer(
            duration: AppAnimations.short,
            width: i == step ? 24 : 8,
            height: 6,
            decoration: BoxDecoration(
              color: i <= step ? AppColors.accent : AppColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          if (i < total - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _StepHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.screenTitle),
        const SizedBox(height: 6),
        Text(subtitle, style: AppTextStyles.bodySecondary),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ═══ Step 1 — Type ════════════════════════════════════════════════

class _TypeStep extends StatelessWidget {
  final ValueType value;
  final ValueChanged<ValueType> onSelected;
  const _TypeStep({required this.value, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      children: [
        const _StepHeader(
          title: S.stepTypeTitle,
          subtitle: 'Pick how entries will be measured.',
        ),
        for (final t in ValueType.values) ...[
          _TypeCard(
            type: t,
            isSelected: value == t,
            onTap: () => onSelected(t),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final ValueType type;
  final bool isSelected;
  final VoidCallback onTap;
  const _TypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, title, desc) = switch (type) {
      ValueType.number => (Icons.tag, 'Number', 'Scores, revenue, counts — e.g. 48.2, 156'),
      ValueType.duration => (Icons.timer_outlined, 'Duration', 'Time — e.g. 15:23, 1:02:45'),
      ValueType.text => (Icons.short_text, 'Text', 'Manual ranking — e.g. "Completed Q4"'),
    };
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withAlpha(25) : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withAlpha(isSelected ? 50 : 20),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: AppColors.accent, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: AppTextStyles.badge
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.accent, size: 20),
          ],
        ),
      ),
    );
  }
}

// ═══ Step 2 — Identity ════════════════════════════════════════════

class _IdentityStep extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController scopeController;
  final String? category;
  final ValueChanged<String?> onCategoryChanged;
  final String? titleError;
  final VoidCallback onTitleChanged;

  const _IdentityStep({
    required this.titleController,
    required this.scopeController,
    required this.category,
    required this.onCategoryChanged,
    required this.titleError,
    required this.onTitleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      children: [
        const _StepHeader(
          title: S.stepIdentityTitle,
          subtitle: 'Give it a clear title and pick a category.',
        ),
        Text(S.boardIdentifier,
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        TextField(
          controller: titleController,
          style: AppTextStyles.body,
          autofocus: true,
          onChanged: (_) => onTitleChanged(),
          decoration: InputDecoration(
            hintText: S.boardIdentifierHint,
            hintStyle: AppTextStyles.bodySecondary
                .copyWith(color: AppColors.textTertiary),
            errorText: titleError,
          ),
        ),
        const SizedBox(height: 24),
        Text(S.scopeObjective,
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        TextField(
          controller: scopeController,
          maxLines: 3,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: S.scopeHint,
            hintStyle: AppTextStyles.bodySecondary
                .copyWith(color: AppColors.textTertiary),
          ),
        ),
        const SizedBox(height: 24),
        Text(S.category,
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BoardCategory.all.map((cat) {
            final isSelected = category == cat;
            return GestureDetector(
              onTap: () => onCategoryChanged(isSelected ? null : cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withAlpha(25)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  cat,
                  style: AppTextStyles.badge.copyWith(
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Text(
          category != null ? S.categoryDeselectHint : S.categoryHelp,
          style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

// ═══ Step 3 — Rules ═══════════════════════════════════════════════

class _RulesStep extends StatelessWidget {
  final ValueType valueType;
  final RankOrder rankOrder;
  final ValueChanged<RankOrder> onRankOrderChanged;
  final bool isPublic;
  final ValueChanged<bool> onPublicChanged;
  final TextEditingController rulesController;

  const _RulesStep({
    required this.valueType,
    required this.rankOrder,
    required this.onRankOrderChanged,
    required this.isPublic,
    required this.onPublicChanged,
    required this.rulesController,
  });

  @override
  Widget build(BuildContext context) {
    final isText = valueType == ValueType.text;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      children: [
        const _StepHeader(
          title: S.stepRulesTitle,
          subtitle: 'How do entries rank, and who can see the board?',
        ),
        // Rank order
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.rankOrder,
                  style: AppTextStyles.body
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                isText
                    ? S.manualRankingText
                    : rankOrder == RankOrder.desc
                        ? S.highestWins
                        : S.lowestWins,
                style: AppTextStyles.badge
                    .copyWith(color: AppColors.textTertiary),
              ),
              if (!isText) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    _OrderChip(
                      label: S.highToLow,
                      isSelected: rankOrder == RankOrder.desc,
                      onTap: () => onRankOrderChanged(RankOrder.desc),
                    ),
                    const SizedBox(width: 8),
                    _OrderChip(
                      label: S.lowToHigh,
                      isSelected: rankOrder == RankOrder.asc,
                      onTap: () => onRankOrderChanged(RankOrder.asc),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Public toggle
        Container(
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
                    Text(
                      S.publicRegistry,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      S.visibleToAll,
                      style: AppTextStyles.badge
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
              Switch(value: isPublic, onChanged: onPublicChanged),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Rules
        Text(S.executionRules,
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        TextField(
          controller: rulesController,
          maxLines: 3,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: S.rulesHint,
            hintStyle: AppTextStyles.bodySecondary
                .copyWith(color: AppColors.textTertiary),
          ),
        ),
      ],
    );
  }
}

class _OrderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _OrderChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.card,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.badge.copyWith(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ═══ Step 4 — Share (preview + comms) ═════════════════════════════

class _ShareStep extends StatelessWidget {
  final TextEditingController telegramController;
  final TextEditingController whatsappController;
  final TextEditingController discordController;
  final String title;
  final ValueType valueType;
  final RankOrder rankOrder;
  final bool isPublic;
  final String? category;
  final String scope;

  const _ShareStep({
    required this.telegramController,
    required this.whatsappController,
    required this.discordController,
    required this.title,
    required this.valueType,
    required this.rankOrder,
    required this.isPublic,
    required this.category,
    required this.scope,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      children: [
        const _StepHeader(
          title: S.stepShareTitle,
          subtitle: 'Optionally add chat channels, then create.',
        ),
        // Preview
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.accent.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.isEmpty ? '—' : title.toUpperCase(),
                style: AppTextStyles.boardTitle,
              ),
              if (scope.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  scope,
                  style: AppTextStyles.bodySecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _PreviewChip(
                    label: valueType.name.toUpperCase(),
                    color: AppColors.accent,
                  ),
                  _PreviewChip(
                    label: rankOrder == RankOrder.desc
                        ? S.highestWinsShort
                        : S.lowestWinsShort,
                    color: AppColors.textSecondary,
                  ),
                  _PreviewChip(
                    label: isPublic ? S.publicLabel : S.privateLabel,
                    color: isPublic ? AppColors.success : AppColors.warning,
                  ),
                  if (category != null)
                    _PreviewChip(
                      label: category!,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(S.commsChannels,
                style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
            const SizedBox(width: 6),
            Text(
              '— ${S.optional}',
              style: AppTextStyles.badge
                  .copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _CommsField(
          controller: telegramController,
          hint: 'https://t.me/...',
          icon: Icons.send,
        ),
        const SizedBox(height: 10),
        _CommsField(
          controller: whatsappController,
          hint: 'https://wa.me/...',
          icon: Icons.chat,
        ),
        const SizedBox(height: 10),
        _CommsField(
          controller: discordController,
          hint: 'https://discord.gg/...',
          icon: Icons.headphones,
        ),
        const SizedBox(height: 16),
        Text(
          S.termsAgreement,
          style: AppTextStyles.badge.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PreviewChip extends StatelessWidget {
  final String label;
  final Color color;
  const _PreviewChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(label, style: AppTextStyles.badge.copyWith(color: color)),
    );
  }
}

class _CommsField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  const _CommsField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTextStyles.body.copyWith(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodySecondary
            .copyWith(color: AppColors.textTertiary),
        prefixIcon: Icon(icon, color: AppColors.textTertiary, size: 18),
        prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
