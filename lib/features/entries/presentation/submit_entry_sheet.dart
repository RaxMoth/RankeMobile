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
  final String? telegramLink;
  final String? whatsappLink;
  final String? discordLink;

  const SubmitEntrySheet({
    super.key,
    required this.listId,
    required this.valueType,
    this.telegramLink,
    this.whatsappLink,
    this.discordLink,
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
  bool _submitted = false;
  String? _valueError;

  bool get _hasCommsLinks =>
      widget.telegramLink != null ||
      widget.whatsappLink != null ||
      widget.discordLink != null;

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
      HapticFeedback.mediumImpact();
      if (mounted) setState(() => _submitted = true);
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
      child: _submitted ? _buildSuccessState() : _buildForm(),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(height: 32),
        const _AnimatedCheckmark(),
        const SizedBox(height: 20),
        Text('SUBMISSION RECEIVED', style: AppTextStyles.screenTitle),
        const SizedBox(height: 8),
        Text(
          'PENDING ADMIN APPROVAL',
          style: AppTextStyles.subtitle.copyWith(letterSpacing: 2.0),
        ),
        const SizedBox(height: 8),
        Text(
          'Your entry will appear in standings\nonce approved by a moderator.',
          style: AppTextStyles.bodySecondary,
          textAlign: TextAlign.center,
        ),
        if (_hasCommsLinks) ...[
          const SizedBox(height: 20),
          _buildProofPrompt(),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('DONE'),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
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
        // Proof prompt
        if (_hasCommsLinks) ...[
          const SizedBox(height: 12),
          _buildProofPrompt(),
        ],
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
    );
  }

  Widget _buildProofPrompt() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
              const Icon(Icons.verified_outlined,
                  color: AppColors.accent, size: 16),
              const SizedBox(width: 8),
              Text('SHARE PROOF IN COMMUNITY',
                  style: AppTextStyles.badge.copyWith(color: AppColors.accent)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Send evidence (photos, videos) in the group chat to help admins verify your entry.',
            style: AppTextStyles.badge.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          if (widget.telegramLink != null)
            _proofLink(Icons.send, 'TELEGRAM', widget.telegramLink!),
          if (widget.whatsappLink != null)
            _proofLink(Icons.chat, 'WHATSAPP', widget.whatsappLink!),
          if (widget.discordLink != null)
            _proofLink(Icons.headphones, 'DISCORD', widget.discordLink!),
        ],
      ),
    );
  }

  Widget _proofLink(IconData icon, String label, String link) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
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
            Icon(icon, color: AppColors.textSecondary, size: 14),
            const SizedBox(width: 8),
            Text(label,
                style: AppTextStyles.badge
                    .copyWith(color: AppColors.textSecondary)),
            const Spacer(),
            const Icon(Icons.open_in_new,
                color: AppColors.textTertiary, size: 11),
          ],
        ),
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

/// Animated checkmark with scale-in and ring pulse effect.
class _AnimatedCheckmark extends StatefulWidget {
  const _AnimatedCheckmark();

  @override
  State<_AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<_AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _ringAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    _ringAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 72,
          height: 72,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Expanding ring
              Transform.scale(
                scale: 1.0 + (_ringAnim.value * 0.4),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent
                          .withAlpha((100 * (1 - _ringAnim.value)).round()),
                      width: 2,
                    ),
                  ),
                ),
              ),
              // Check circle
              Transform.scale(
                scale: _scaleAnim.value,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(25),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                  child: const Icon(
                      Icons.check, color: AppColors.accent, size: 28),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
