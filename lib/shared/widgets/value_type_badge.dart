import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../features/lists/domain/entities/ranked_list.dart';

/// Colored pill badge showing the value type of a list
class ValueTypeBadge extends StatelessWidget {
  final ValueType valueType;

  const ValueTypeBadge({super.key, required this.valueType});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (valueType) {
      ValueType.number => ('NUMBER', AppColors.accent),
      ValueType.duration => ('DURATION', Colors.orange),
      ValueType.text => ('TEXT', AppColors.categoryCoding),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: AppTextStyles.badge.copyWith(color: color),
      ),
    );
  }
}
