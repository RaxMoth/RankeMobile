import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// iOS-style drag handle shown at the top of bottom sheets.
/// Keeps every sheet visually consistent.
class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
