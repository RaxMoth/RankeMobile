import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dev/mock_lists_repository.dart';
import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';

class CreateListScreen extends ConsumerStatefulWidget {
  const CreateListScreen({super.key});

  @override
  ConsumerState<CreateListScreen> createState() => _CreateListScreenState();
}

class _CreateListScreenState extends ConsumerState<CreateListScreen> {
  final _titleController = TextEditingController();
  final _scopeController = TextEditingController();
  final _rulesController = TextEditingController();
  final _telegramController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _discordController = TextEditingController();
  bool _isPublic = true;
  bool _showCommsFields = false;
  ValueType _valueType = ValueType.number;
  RankOrder _rankOrder = RankOrder.desc;
  String? _category;
  bool _isSubmitting = false;
  String? _titleError;

  @override
  void dispose() {
    _titleController.dispose();
    _scopeController.dispose();
    _rulesController.dispose();
    _telegramController.dispose();
    _whatsappController.dispose();
    _discordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
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
      HapticFeedback.mediumImpact();
      if (mounted) context.go('/home');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.createBoard, style: AppTextStyles.screenTitle),
                  TextButton(
                    onPressed: () => context.go('/home'),
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 24),
                  _buildField(
                    label: S.boardIdentifier,
                    controller: _titleController,
                    hint: S.boardIdentifierHint,
                    errorText: _titleError,
                  ),
                  const SizedBox(height: 24),
                  _buildField(
                    label: S.scopeObjective,
                    controller: _scopeController,
                    hint: S.scopeHint,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  _buildValueTypePicker(),
                  const SizedBox(height: 24),
                  _buildRankOrderToggle(),
                  const SizedBox(height: 24),
                  _buildPublicToggle(),
                  const SizedBox(height: 24),
                  _buildCategoryPicker(),
                  const SizedBox(height: 24),
                  _buildRulesField(),
                  const SizedBox(height: 24),
                  _buildCommsSection(),
                  const SizedBox(height: 16),
                  Text(
                    S.termsAgreement,
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  _buildCreateButton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.body,
          onChanged: (_) {
            if (_titleError != null && controller == _titleController) {
              setState(() => _titleError = null);
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }

  Widget _buildValueTypePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.valueType,
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        Row(
          children: ValueType.values.map((type) {
            final isSelected = type == _valueType;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _valueType = type;
                    if (type == ValueType.text) _rankOrder = RankOrder.asc;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  margin: EdgeInsets.only(
                    right: type != ValueType.text ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent.withAlpha(25)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _iconForType(type),
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.textTertiary,
                        size: 20,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        type.name.toUpperCase(),
                        style: AppTextStyles.badge.copyWith(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Text(
          _descriptionForType(_valueType),
          style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildRankOrderToggle() {
    final isText = _valueType == ValueType.text;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isText ? AppColors.surface.withAlpha(100) : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.rankOrder,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isText ? AppColors.textTertiary : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isText
                    ? S.manualRankingText
                    : _rankOrder == RankOrder.desc
                        ? S.highestWins
                        : S.lowestWins,
                style:
                    AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
          if (!isText)
            Row(
              children: [
                _orderChip(S.highToLow, RankOrder.desc),
                const SizedBox(width: 8),
                _orderChip(S.lowToHigh, RankOrder.asc),
              ],
            ),
        ],
      ),
    );
  }

  Widget _orderChip(String label, RankOrder order) {
    final isSelected = _rankOrder == order;
    return GestureDetector(
      onTap: () => setState(() => _rankOrder = order),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

  Widget _buildPublicToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.publicRegistry,
                style: AppTextStyles.body
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                S.visibleToAll,
                style:
                    AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
          Switch(
            value: _isPublic,
            onChanged: (v) => setState(() => _isPublic = v),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.category,
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BoardCategory.all.map((cat) {
            final isSelected = _category == cat;
            return GestureDetector(
              onTap: () =>
                  setState(() => _category = isSelected ? null : cat),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          _category != null ? S.categoryDeselectHint : S.categoryHelp,
          style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildRulesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.executionRules,
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 3,
                height: 60,
                margin: const EdgeInsets.only(left: 12, top: 12),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _rulesController,
                  maxLines: 2,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: S.rulesHint,
                    hintStyle: AppTextStyles.bodySecondary.copyWith(
                      color: AppColors.accentDim,
                      letterSpacing: 0.5,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: AppColors.transparent,
                    filled: false,
                    contentPadding: const EdgeInsets.fromLTRB(12, 14, 16, 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _showCommsFields = !_showCommsFields),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.commsChannels,
                    style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
                Row(
                  children: [
                    Text(S.optional,
                        style: AppTextStyles.badge
                            .copyWith(color: AppColors.textTertiary)),
                    const SizedBox(width: 8),
                    Icon(
                      _showCommsFields
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_showCommsFields) ...[
          const SizedBox(height: 10),
          _commsField(_telegramController, 'https://t.me/...', Icons.send),
          const SizedBox(height: 10),
          _commsField(_whatsappController, 'https://wa.me/...', Icons.chat),
          const SizedBox(height: 10),
          _commsField(
              _discordController, 'https://discord.gg/...', Icons.headphones),
        ],
      ],
    );
  }

  Widget _commsField(
      TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      style: AppTextStyles.body.copyWith(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            AppTextStyles.bodySecondary.copyWith(color: AppColors.textTertiary),
        prefixIcon: Icon(icon, color: AppColors.textTertiary, size: 18),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 40, minHeight: 0),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _showPreview,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
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
            : const Text(S.previewCreate),
      ),
    );
  }

  void _showPreview() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = S.boardIdentifierRequired);
      return;
    }
    setState(() => _titleError = null);

    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(S.boardPreview, style: AppTextStyles.screenTitle),
            const SizedBox(height: 20),
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
                  Text(title.toUpperCase(), style: AppTextStyles.boardTitle),
                  if (_scopeController.text.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _scopeController.text.trim(),
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
                      _previewChip(
                          _valueType.name.toUpperCase(), AppColors.accent),
                      _previewChip(
                        _rankOrder == RankOrder.desc
                            ? S.highestWinsShort
                            : S.lowestWinsShort,
                        AppColors.textSecondary,
                      ),
                      _previewChip(
                        _isPublic ? S.publicLabel : S.privateLabel,
                        _isPublic ? AppColors.success : AppColors.warning,
                      ),
                      if (_category != null)
                        _previewChip(_category!, AppColors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(S.edit,
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _submit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(S.create,
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.background)),
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

  Widget _previewChip(String label, Color color) {
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

  IconData _iconForType(ValueType type) {
    return switch (type) {
      ValueType.number => Icons.tag,
      ValueType.duration => Icons.timer_outlined,
      ValueType.text => Icons.text_fields,
    };
  }

  String _descriptionForType(ValueType type) {
    return switch (type) {
      ValueType.number => S.valueTypeNumber,
      ValueType.duration => S.valueTypeDuration,
      ValueType.text => S.valueTypeText,
    };
  }
}
