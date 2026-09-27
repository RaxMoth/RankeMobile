import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// Shown at launch while the stored session is being restored, so the app
/// never flashes the login screen for a signed-in user (or Home for a
/// signed-out one).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
    );
  }
}
