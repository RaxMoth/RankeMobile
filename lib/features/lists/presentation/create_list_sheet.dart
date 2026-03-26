import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';

/// Create list screen — "INITIALIZE" new leaderboard registry
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
      setState(() => _titleError = 'BOARD IDENTIFIER REQUIRED');
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
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('FAILED TO CREATE BOARD: $e'),
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
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 24),
                  _buildField(
                    label: 'BOARD IDENTIFIER',
                    controller: _titleController,
                    hint: 'E.G. Q4 REVENUE GAINS',
                    errorText: _titleError,
                  ),
                  const SizedBox(height: 24),
                  _buildField(
                    label: 'SCOPE & OBJECTIVE',
                    controller: _scopeController,
                    hint: 'DESCRIBE THE CRITERIA FOR ENTRY...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  _buildValueTypePicker(),
                  const SizedBox(height: 24),
                  _buildRankOrderToggle(),
                  const SizedBox(height: 24),
                  _buildPublicToggle(),
                  const SizedBox(height: 24),
                  _buildRulesField(),
                  const SizedBox(height: 24),
                  _buildCommsSection(),
                  const SizedBox(height: 16),
                  Text(
                    'AGREEMENT OF TERMINAL SERVICE TERMS REQUIRED',
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INITIALIZE', style: AppTextStyles.displayLarge),
              const SizedBox(height: 2),
              Text('DRAFTING NEW REGISTRY', style: AppTextStyles.subtitle),
            ],
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'CANCEL',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
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
        Text('VALUE TYPE',
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
                    // Text type is always manual ranking
                    if (type == ValueType.text) {
                      _rankOrder = RankOrder.asc;
                    }
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
                      color:
                          isSelected ? AppColors.accent : AppColors.border,
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
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
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
                'RANK ORDER',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isText ? AppColors.textTertiary : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isText
                    ? 'MANUAL RANKING FOR TEXT'
                    : _rankOrder == RankOrder.desc
                        ? 'HIGHEST VALUE WINS'
                        : 'LOWEST VALUE WINS',
                style:
                    AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
          if (!isText)
            Row(
              children: [
                _orderChip('HIGH\u2192LOW', RankOrder.desc),
                const SizedBox(width: 8),
                _orderChip('LOW\u2192HIGH', RankOrder.asc),
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
                'PUBLIC REGISTRY',
                style: AppTextStyles.body
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                'VISIBLE TO ALL APEX USERS',
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

  Widget _buildRulesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXECUTION RULES (OPTIONAL)',
          style: AppTextStyles.sectionHeader.copyWith(fontSize: 11),
        ),
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
                    hintText: 'SPECIFY EVIDENCE REQUIREMENTS...',
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
                Text(
                  'COMMUNICATION CHANNELS',
                  style: AppTextStyles.sectionHeader.copyWith(fontSize: 11),
                ),
                Row(
                  children: [
                    Text(
                      'OPTIONAL',
                      style: AppTextStyles.badge
                          .copyWith(color: AppColors.textTertiary),
                    ),
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
          _commsField(
              _telegramController, 'https://t.me/...', Icons.send),
          const SizedBox(height: 10),
          _commsField(
              _whatsappController, 'https://wa.me/...', Icons.chat),
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
        onPressed: _isSubmitting ? null : _submit,
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
            : const Text('CREATE LEADERBOARD'),
      ),
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
      ValueType.number =>
        'NUMERIC VALUES \u2022 e.g. 48.2, 156, 31240',
      ValueType.duration =>
        'TIME-BASED VALUES \u2022 e.g. 15:23, 1:02:45',
      ValueType.text =>
        'TEXT ENTRIES WITH MANUAL RANKING \u2022 e.g. "Completed Q4"',
    };
  }
}
