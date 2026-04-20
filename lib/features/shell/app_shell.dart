import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/strings.dart';
import '../../core/theme/colors.dart';
import 'pending_badge_provider.dart';

/// Persistent bottom navigation shell wrapping the 4 main tabs.
class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  static const double _minSwipeDistance = 56;
  static const double _horizontalDominance = 1.35;
  static const Duration _swipeCooldown = Duration(milliseconds: 250);

  double _dragDx = 0;
  double _dragDy = 0;
  DateTime? _lastSwipeAt;

  void _onHorizontalDragStart(DragStartDetails details) {
    _dragDx = 0;
    _dragDy = 0;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDx += details.delta.dx;
    _dragDy += details.delta.dy;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final now = DateTime.now();
    if (_lastSwipeAt != null &&
        now.difference(_lastSwipeAt!) < _swipeCooldown) {
      return;
    }

    final isHorizontalGesture =
        _dragDx.abs() > (_dragDy.abs() * _horizontalDominance);
    if (!isHorizontalGesture || _dragDx.abs() < _minSwipeDistance) {
      return;
    }

    final isSwipeLeft = _dragDx < 0;
    final current = widget.navigationShell.currentIndex;
    final target = isSwipeLeft ? current + 1 : current - 1;

    if (target < 0 || target > 2) {
      return;
    }

    _lastSwipeAt = now;
    widget.navigationShell.goBranch(target);
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = ref.watch(pendingCountProvider);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (index) => widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: pendingCount > 0,
                label: Text(
                  pendingCount > 9 ? S.badgeOverflow : '$pendingCount',
                  style: const TextStyle(fontSize: 9),
                ),
                backgroundColor: AppColors.accent,
                child: const Icon(Icons.grid_view_rounded, size: 24),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined, size: 24),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
