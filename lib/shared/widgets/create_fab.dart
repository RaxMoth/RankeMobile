import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';

/// Floating action button that opens the board-creation flow as a pushed modal.
/// Used on Home and Discover screens.
class CreateFab extends StatelessWidget {
  const CreateFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        context.push('/create');
      },
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.background,
      elevation: 2,
      child: const Icon(Icons.add, size: 26),
    );
  }
}
