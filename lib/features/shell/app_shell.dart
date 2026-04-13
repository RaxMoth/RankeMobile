import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';
import 'pending_badge_provider.dart';

/// Persistent bottom navigation shell wrapping the 4 main tabs.
class AppShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(pendingCountProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: pendingCount > 0,
                label: Text(
                  pendingCount > 9 ? '9+' : '$pendingCount',
                  style: const TextStyle(fontSize: 9),
                ),
                backgroundColor: AppColors.accent,
                child: const Icon(Icons.grid_view_rounded, size: 22),
              ),
              label: 'HOME',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined, size: 22),
              label: 'DISCOVER',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 22),
              label: 'CREATE',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 22),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
