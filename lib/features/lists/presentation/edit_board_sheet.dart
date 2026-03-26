import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';

/// Bottom sheet for editing board details (admin/owner only).
class EditBoardSheet extends ConsumerStatefulWidget {
  final String listId;
  final RankedList list;

  const EditBoardSheet({
    super.key,
    required this.listId,
    required this.list,
  });

  @override
  ConsumerState<EditBoardSheet> createState() => _EditBoardSheetState();
}

class _EditBoardSheetState extends ConsumerState<EditBoardSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _telegramController;
  late final TextEditingController _whatsappController;
  late final TextEditingController _discordController;
  late bool _isPublic;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.list.title);
    _descriptionController =
        TextEditingController(text: widget.list.description ?? '');
    _telegramController =
        TextEditingController(text: widget.list.telegramLink ?? '');
    _whatsappController =
        TextEditingController(text: widget.list.whatsappLink ?? '');
    _discordController =
        TextEditingController(text: widget.list.discordLink ?? '');
    _isPublic = widget.list.isPublic;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _telegramController.dispose();
    _whatsappController.dispose();
    _discordController.dispose();
    super.dispose();
  }

  String? _changedOrNull(String current, String? original) {
    final trimmed = current.trim();
    if (trimmed == (original ?? '')) return null;
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(listDetailProvider(widget.listId).notifier).updateList(
            title: title != widget.list.title ? title : null,
            description: _changedOrNull(
                _descriptionController.text, widget.list.description),
            isPublic: _isPublic != widget.list.isPublic ? _isPublic : null,
            telegramLink: _changedOrNull(
                _telegramController.text, widget.list.telegramLink),
            whatsappLink: _changedOrNull(
                _whatsappController.text, widget.list.whatsappLink),
            discordLink: _changedOrNull(
                _discordController.text, widget.list.discordLink),
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('FAILED TO UPDATE: $e'),
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
        20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text('EDIT BOARD', style: AppTextStyles.screenTitle),
            const SizedBox(height: 24),
            // Title
            Text('TITLE',
                style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: AppTextStyles.body,
              decoration: const InputDecoration(hintText: 'BOARD TITLE'),
            ),
            const SizedBox(height: 20),
            // Description
            Text('DESCRIPTION',
                style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              style: AppTextStyles.body,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: 'DESCRIBE THE BOARD...'),
            ),
            const SizedBox(height: 20),
            // Communication channels
            Text('COMMUNICATION CHANNELS',
                style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
            const SizedBox(height: 8),
            _commsField(_telegramController, 'TELEGRAM',
                'https://t.me/...', Icons.send),
            const SizedBox(height: 10),
            _commsField(_whatsappController, 'WHATSAPP',
                'https://wa.me/...', Icons.chat),
            const SizedBox(height: 10),
            _commsField(_discordController, 'DISCORD',
                'https://discord.gg/...', Icons.headphones),
            const SizedBox(height: 20),
            // Public toggle
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PUBLIC',
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w700)),
                  Switch(
                    value: _isPublic,
                    onChanged: (v) => setState(() => _isPublic = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Save
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _save,
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
                    : const Text('SAVE CHANGES'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _commsField(TextEditingController controller, String label,
      String hint, IconData icon) {
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
}
