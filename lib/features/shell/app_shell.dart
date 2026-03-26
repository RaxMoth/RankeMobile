import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';

/// Persistent bottom navigation shell wrapping the 4 main tabs.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded, size: 22),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined, size: 22),
              label: 'DISCOVER',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 22),
              label: 'CREATE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 22),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
