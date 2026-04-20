import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

/// Single tappable row inside a bottom-sheet menu: leading icon + label.
///
/// Use [destructive] for sign-out / delete rows (tints label + icon red).
/// Use [iconColor] when the icon needs a specific accent (e.g. an active
/// bookmark glowing amber) — otherwise it inherits the label color.
class SheetActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;
  final Color? iconColor;

  const SheetActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        destructive ? AppColors.error : AppColors.textPrimary;
    final iColor = iconColor ?? textColor;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iColor),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
