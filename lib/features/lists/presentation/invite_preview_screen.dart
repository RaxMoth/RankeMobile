import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

/// Invite preview screen — shown via deep link
class InvitePreviewScreen extends StatelessWidget {
  final String token;

  const InvitePreviewScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'INVITE PREVIEW\n(NOT YET IMPLEMENTED)',
            style: AppTextStyles.sectionHeader.copyWith(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
