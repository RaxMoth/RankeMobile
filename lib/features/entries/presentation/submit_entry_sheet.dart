import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../lists/domain/entities/ranked_list.dart';
import '../../lists/presentation/providers/lists_provider.dart';
import '../domain/entities/entry.dart';
import 'widgets/duration_picker.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _noteController = TextEditingController();
  int _durationMs = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _valueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final input = switch (widget.valueType) {
      ValueType.number => EntryInput(
          valueNumber: double.tryParse(_valueController.text),
          note: _noteText,
        ),
      ValueType.duration => EntryInput(
          valueDurationMs: _durationMs,
          note: _noteText,
        ),
      ValueType.text => EntryInput(
          valueText: _valueController.text.trim(),
          note: _noteText,
        ),
    };

    try {
      await ref
          .read(listDetailProvider(widget.listId).notifier)
          .submitEntry(input);
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

  String? get _noteText {
    final text = _noteController.text.trim();
    return text.isEmpty ? null : text;
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
              'Submit Entry',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildValueInput(),
            const SizedBox(height: 12),
            AppTextField(
              controller: _noteController,
              label: 'Note (optional)',
              maxLength: 200,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Submit',
              onPressed: _submit,
              isLoading: _isSubmitting,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueInput() {
    return switch (widget.valueType) {
      ValueType.number => AppTextField(
          controller: _valueController,
          label: 'Value',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Value is required';
            if (double.tryParse(v) == null) return 'Enter a valid number';
            return null;
          },
        ),
      ValueType.duration => DurationPickerWidget(
          onChanged: (ms) => _durationMs = ms,
        ),
      ValueType.text => AppTextField(
          controller: _valueController,
          label: 'Value',
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Value is required'
              : null,
        ),
    };
  }
=======

/// Bottom sheet for submitting an entry to a ranked list
class SubmitEntrySheet extends StatelessWidget {
  final String listId;

  const SubmitEntrySheet({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text('Submit Entry Sheet\n(Not yet implemented)', textAlign: TextAlign.center),
    );
  }
>>>>>>> 88d3438 (good progress)
}
