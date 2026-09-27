import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/confirm_sheet.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';
import 'widgets/category_picker.dart';

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
  late String? _category;
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
    _category = widget.list.category;
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

  /// PATCH value for an optional text field: null when unchanged (the key
  /// is omitted), "" when the user cleared it (the API clears the field),
  /// otherwise the new value.
  String? _patch(String? current, String? original) {
    final value = current?.trim() ?? '';
    return value == (original ?? '') ? null : value;
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(listDetailProvider(widget.listId).notifier).updateList(
            title: title != widget.list.title ? title : null,
            description: _patch(
                _descriptionController.text, widget.list.description),
            isPublic: _isPublic != widget.list.isPublic ? _isPublic : null,
            category: _patch(_category, widget.list.category),
            telegramLink: _patch(
                _telegramController.text, widget.list.telegramLink),
            whatsappLink: _patch(
                _whatsappController.text, widget.list.whatsappLink),
            discordLink: _patch(
                _discordController.text, widget.list.discordLink),
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, S.failedToUpdate(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          // viewInsetsOf scopes the rebuild to keyboard-only changes.
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom,
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
            Text(S.editBoard, style: AppTextStyles.screenTitle),
            const SizedBox(height: 24),
            // Title
            Text(S.title,
                style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: AppTextStyles.body,
              decoration: const InputDecoration(hintText: S.boardTitle),
            ),
            const SizedBox(height: 20),
            // Description
            Text(S.description,
                style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              style: AppTextStyles.body,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: S.describeBoard),
            ),
            const SizedBox(height: 20),
            // Category
            Text(S.category,
                style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
            const SizedBox(height: 8),
            CategoryPicker(
              category: _category,
              onChanged: (c) => setState(() => _category = c),
            ),
            const SizedBox(height: 20),
            // Communication channels
            Text(S.commsChannels,
                style: AppTextStyles.sectionHeader.copyWith(fontSize: 11)),
            const SizedBox(height: 8),
            _commsField(_telegramController, S.telegram,
                'https://t.me/...', Icons.send),
            const SizedBox(height: 10),
            _commsField(_whatsappController, S.whatsapp,
                'https://wa.me/...', Icons.chat),
            const SizedBox(height: 10),
            _commsField(_discordController, S.discord,
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
                  Text(S.publicLabel,
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
                    : const Text(S.saveChanges),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
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
