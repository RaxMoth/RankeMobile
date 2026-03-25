import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';

class CreateListSheet extends ConsumerStatefulWidget {
  const CreateListSheet({super.key});

  @override
  ConsumerState<CreateListSheet> createState() => _CreateListSheetState();
}

class _CreateListSheetState extends ConsumerState<CreateListSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  ValueType _valueType = ValueType.number;
  RankOrder _rankOrder = RankOrder.desc;
  bool _isPublic = false;
  bool _isSubmitting = false;
=======
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

/// Create list screen — "INITIALIZE" new leaderboard registry
class CreateListScreen extends StatefulWidget {
  const CreateListScreen({super.key});

  @override
  State<CreateListScreen> createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  final _titleController = TextEditingController();
  final _scopeController = TextEditingController();
  final _metricController = TextEditingController();
  final _rulesController = TextEditingController();
  bool _isPublic = true;
>>>>>>> 88d3438 (good progress)

  @override
  void dispose() {
    _titleController.dispose();
<<<<<<< HEAD
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      await ref.read(listsProvider.notifier).createList(
            title: _titleController.text.trim(),
            description: _descController.text.trim().isEmpty
                ? null
                : _descController.text.trim(),
            valueType: _valueType,
            rankOrder: _rankOrder,
            isPublic: _isPublic,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'Create List',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _titleController,
              label: 'Title',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _descController,
              label: 'Description (optional)',
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Text('Value Type',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<ValueType>(
              segments: const [
                ButtonSegment(
                    value: ValueType.number,
                    label: Text('Number'),
                    icon: Icon(Icons.tag)),
                ButtonSegment(
                    value: ValueType.duration,
                    label: Text('Duration'),
                    icon: Icon(Icons.timer)),
                ButtonSegment(
                    value: ValueType.text,
                    label: Text('Text'),
                    icon: Icon(Icons.text_fields)),
              ],
              selected: {_valueType},
              onSelectionChanged: (v) => setState(() {
                _valueType = v.first;
              }),
            ),
            const SizedBox(height: 16),
            if (_valueType != ValueType.text) ...[
              Text('Rank Order',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<RankOrder>(
                segments: const [
                  ButtonSegment(
                      value: RankOrder.desc, label: Text('High to Low')),
                  ButtonSegment(
                      value: RankOrder.asc, label: Text('Low to High')),
                ],
                selected: {_rankOrder},
                onSelectionChanged: (v) =>
                    setState(() => _rankOrder = v.first),
              ),
              const SizedBox(height: 16),
            ],
            SwitchListTile(
              title: const Text('Public'),
              subtitle: const Text('Anyone with the link can view'),
              value: _isPublic,
              onChanged: (v) => setState(() => _isPublic = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Create',
              onPressed: _submit,
              isLoading: _isSubmitting,
              width: double.infinity,
=======
    _scopeController.dispose();
    _metricController.dispose();
    _rulesController.dispose();
    super.dispose();
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
                  ),
                  const SizedBox(height: 24),
                  _buildField(
                    label: 'SCOPE & OBJECTIVE',
                    controller: _scopeController,
                    hint: 'DESCRIBE THE CRITERIA FOR ENTRY...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  _buildPublicToggle(),
                  const SizedBox(height: 24),
                  _buildMetricField(),
                  const SizedBox(height: 24),
                  _buildRulesField(),
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
>>>>>>> 88d3438 (good progress)
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

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
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
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
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                'VISIBLE TO ALL APEX USERS',
                style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
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

  Widget _buildMetricField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RANKING METRIC', style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        TextField(
          controller: _metricController,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: 'E.G. USD, SECONDS, SCORE',
            hintStyle: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
            suffixIcon: const Icon(Icons.tune, color: AppColors.textTertiary, size: 20),
          ),
        ),
      ],
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

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: create list via use case
          context.pop();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: const Text('CREATE LEADERBOARD'),
      ),
    );
  }
>>>>>>> 88d3438 (good progress)
}
