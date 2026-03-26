import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../lists/domain/entities/ranked_list.dart';
import '../../lists/presentation/providers/lists_provider.dart';
import '../domain/entities/entry.dart';
import 'widgets/duration_picker.dart';

/// Bottom sheet for submitting an entry to a ranked list.
/// Adapts input type based on the board's ValueType.
class SubmitEntrySheet extends ConsumerStatefulWidget {
  final String listId;
  final ValueType valueType;

  const SubmitEntrySheet({
    super.key,
    required this.listId,
    required this.valueType,
  });

  @override
  ConsumerState<SubmitEntrySheet> createState() => _SubmitEntrySheetState();
}

class _SubmitEntrySheetState extends ConsumerState<SubmitEntrySheet> {
  final _numberController = TextEditingController();
  final _textController = TextEditingController();
  final _noteController = TextEditingController();
  int _durationMs = 0;
  bool _isSubmitting = false;
  String? _valueError;

  @override
  void dispose() {
    _numberController.dispose();
    _textController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Validate
    EntryInput input;
    switch (widget.valueType) {
      case ValueType.number:
        final value = double.tryParse(_numberController.text.trim());
        if (value == null) {
          setState(() => _valueError = 'ENTER A VALID NUMBER');
          return;
        }
        input = EntryInput(
          valueNumber: value,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
      case ValueType.duration:
        if (_durationMs <= 0) {
          setState(() => _valueError = 'ENTER A VALID DURATION');
          return;
        }
        input = EntryInput(
          valueDurationMs: _durationMs,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
      case ValueType.text:
        final value = _textController.text.trim();
        if (value.isEmpty) {
          setState(() => _valueError = 'ENTER A VALUE');
          return;
        }
        input = EntryInput(
          valueText: value,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
    }

    setState(() {
      _valueError = null;
      _isSubmitting = true;
    });

    try {
      await ref
          .read(listDetailProvider(widget.listId).notifier)
          .submitEntry(input);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SUBMISSION FAILED: $e'),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
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
          // Header
          Text('SUBMIT ENTRY', style: AppTextStyles.screenTitle),
          const SizedBox(height: 4),
          Text(
            'VALUE TYPE: ${widget.valueType.name.toUpperCase()}',
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: 24),
          // Value input
          _buildValueInput(),
          if (_valueError != null) ...[
            const SizedBox(height: 8),
            Text(
              _valueError!,
              style: AppTextStyles.badge.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: 20),
          // Note field
          Text('NOTE (OPTIONAL)',
              style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 2,
            maxLength: 200,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'ADD CONTEXT TO YOUR ENTRY...',
              hintStyle: AppTextStyles.bodySecondary.copyWith(
                color: AppColors.textTertiary,
              ),
              counterStyle:
                  AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 20),
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
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
                  : const Text('CONFIRM SUBMISSION'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildValueInput() {
    return switch (widget.valueType) {
      ValueType.number => _buildNumberInput(),
      ValueType.duration => _buildDurationInput(),
      ValueType.text => _buildTextInput(),
    };
  }

  Widget _buildNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('VALUE',
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 8),
        TextField(
          controller: _numberController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
          style: AppTextStyles.valueDisplay,
          onChanged: (_) {
            if (_valueError != null) setState(() => _valueError = null);
          },
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: AppTextStyles.valueDisplay.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DURATION',
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 8),
        DurationPickerWidget(
          onChanged: (ms) {
            _durationMs = ms;
            if (_valueError != null) setState(() => _valueError = null);
          },
        ),
      ],
    );
  }

  Widget _buildTextInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('VALUE',
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
        const SizedBox(height: 8),
        TextField(
          controller: _textController,
          style: AppTextStyles.body,
          onChanged: (_) {
            if (_valueError != null) setState(() => _valueError = null);
          },
          decoration: InputDecoration(
            hintText: 'ENTER YOUR VALUE...',
            hintStyle: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
