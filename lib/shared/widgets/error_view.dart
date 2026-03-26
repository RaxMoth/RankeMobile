import 'package:flutter/material.dart';

import '../../core/network/api_error.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

/// Reusable error display widget that handles ApiError types
class ErrorView extends StatelessWidget {
  final ApiError error;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final message = switch (error) {
      ApiNetworkError() => 'No network connection. Please check your internet.',
      ApiServerError(:final message) => message,
      ApiUnknownError() => 'Something went wrong. Please try again.',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              error is ApiNetworkError ? Icons.wifi_off : Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('RETRY'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
