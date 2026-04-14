import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/strings.dart';

class DurationPickerWidget extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final int? initialMs;

  const DurationPickerWidget({
    super.key,
    required this.onChanged,
    this.initialMs,
  });

  @override
  State<DurationPickerWidget> createState() => _DurationPickerWidgetState();
}

class _DurationPickerWidgetState extends State<DurationPickerWidget> {
  late final TextEditingController _hoursController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    final ms = widget.initialMs ?? 0;
    final totalSeconds = ms ~/ 1000;
    _hoursController =
        TextEditingController(text: (totalSeconds ~/ 3600).toString());
    _minutesController =
        TextEditingController(text: ((totalSeconds % 3600) ~/ 60).toString());
    _secondsController =
        TextEditingController(text: (totalSeconds % 60).toString());
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _onChanged() {
    final h = int.tryParse(_hoursController.text) ?? 0;
    final m = int.tryParse(_minutesController.text) ?? 0;
    final s = int.tryParse(_secondsController.text) ?? 0;
    final totalMs = (h * 3600 + m * 60 + s) * 1000;
    widget.onChanged(totalMs);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TimeField(
          controller: _hoursController,
          label: S.hh,
          onChanged: (_) => _onChanged(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(':', style: TextStyle(fontSize: 24)),
        ),
        _TimeField(
          controller: _minutesController,
          label: S.mm,
          onChanged: (_) => _onChanged(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(':', style: TextStyle(fontSize: 24)),
        ),
        _TimeField(
          controller: _secondsController,
          label: S.ss,
          onChanged: (_) => _onChanged(),
        ),
      ],
    );
  }
}

class _TimeField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;

  const _TimeField({
    required this.controller,
    required this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        decoration: InputDecoration(
          labelText: label,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

String formatDuration(int ms) {
  final totalSeconds = ms ~/ 1000;
  final h = totalSeconds ~/ 3600;
  final m = (totalSeconds % 3600) ~/ 60;
  final s = totalSeconds % 60;
  if (h > 0) {
    return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}
