import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// Shimmer loading placeholder that pulses between two shades.
/// Use as a skeleton placeholder while real data loads.
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 6,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Color.lerp(
              AppColors.surface,
              AppColors.surfaceLight,
              _animation.value,
            ),
          ),
        );
      },
    );
  }
}

/// Pre-built skeleton that mimics a board list tile.
class BoardTileSkeleton extends StatelessWidget {
  const BoardTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const ShimmerBox(width: 44, height: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                    height: 14,
                    width: MediaQuery.sizeOf(context).width * 0.4),
                const SizedBox(height: 8),
                const ShimmerBox(height: 10, width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pre-built skeleton that mimics a standings entry row.
class StandingRowSkeleton extends StatelessWidget {
  const StandingRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          ShimmerBox(width: 28, height: 24),
          SizedBox(width: 12),
          ShimmerBox(width: 40, height: 40),
          SizedBox(width: 12),
          Expanded(child: ShimmerBox(height: 14)),
          SizedBox(width: 12),
          ShimmerBox(width: 50, height: 18),
        ],
      ),
    );
  }
}

/// Loading skeleton for the home / profile screens.
class BoardListSkeleton extends StatelessWidget {
  final int count;

  const BoardListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList.builder(
        itemCount: count + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ShimmerBox(height: 12, width: 120),
            );
          }
          return const BoardTileSkeleton();
        },
      ),
    );
  }
}
