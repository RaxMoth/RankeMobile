import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../../core/network/api_error.dart';

=======

import '../../core/network/api_error.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

/// Reusable error display widget that handles ApiError types
>>>>>>> 88d3438 (good progress)
class ErrorView extends StatelessWidget {
  final ApiError error;
  final VoidCallback? onRetry;

<<<<<<< HEAD
  const ErrorView({super.key, required this.error, this.onRetry});
=======
  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });
>>>>>>> 88d3438 (good progress)

  @override
  Widget build(BuildContext context) {
    final message = switch (error) {
<<<<<<< HEAD
      ApiNetworkError() => 'No internet connection. Please check your network.',
=======
      ApiNetworkError() => 'No network connection. Please check your internet.',
>>>>>>> 88d3438 (good progress)
      ApiServerError(:final message) => message,
      ApiUnknownError() => 'Something went wrong. Please try again.',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
<<<<<<< HEAD
          mainAxisSize: MainAxisSize.min,
=======
          mainAxisAlignment: MainAxisAlignment.center,
>>>>>>> 88d3438 (good progress)
          children: [
            Icon(
              error is ApiNetworkError ? Icons.wifi_off : Icons.error_outline,
              size: 48,
<<<<<<< HEAD
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
=======
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('RETRY'),
>>>>>>> 88d3438 (good progress)
              ),
            ],
          ],
        ),
      ),
    );
  }
}
