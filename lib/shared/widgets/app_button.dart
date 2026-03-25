import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
import '../../core/theme/colors.dart';

/// Reusable app button with loading state
>>>>>>> 88d3438 (good progress)
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
<<<<<<< HEAD
  final bool outlined;
  final IconData? icon;
  final double? width;
=======
  final bool isOutlined;
>>>>>>> 88d3438 (good progress)

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
<<<<<<< HEAD
    this.outlined = false,
    this.icon,
    this.width,
=======
    this.isOutlined = false,
>>>>>>> 88d3438 (good progress)
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              )
            : Text(label);

    final button = outlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: child,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: child,
          );

    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return button;
=======
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(),
      );
    }
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.background,
        ),
      );
    }
    return Text(label);
>>>>>>> 88d3438 (good progress)
  }
}
