import 'package:flutter/material.dart';

import '../../../../core/strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/board_category.dart';

/// Single-select category chips; tapping the selected chip clears it.
class CategoryPicker extends StatelessWidget {
  final String? category;
  final ValueChanged<String?> onChanged;

  const CategoryPicker({
    super.key,
    required this.category,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BoardCategory.all.map((cat) {
            final isSelected = category == cat;
            return GestureDetector(
              onTap: () => onChanged(isSelected ? null : cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withAlpha(25)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  cat,
                  style: AppTextStyles.badge.copyWith(
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Text(
          category != null ? S.categoryDeselectHint : S.categoryHelp,
          style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }
}
