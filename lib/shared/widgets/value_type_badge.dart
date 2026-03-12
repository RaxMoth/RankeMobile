import 'package:flutter/material.dart';
import '../../features/lists/domain/entities/ranked_list.dart';

class ValueTypeBadge extends StatelessWidget {
  final ValueType valueType;

  const ValueTypeBadge({super.key, required this.valueType});

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (valueType) {
      ValueType.number => ('Number', Icons.tag, Colors.blue),
      ValueType.duration => ('Duration', Icons.timer, Colors.orange),
      ValueType.text => ('Text', Icons.text_fields, Colors.purple),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
