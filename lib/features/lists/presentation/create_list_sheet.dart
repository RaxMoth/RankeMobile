import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
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
            ),
          ],
        ),
      ),
    );
  }
}
