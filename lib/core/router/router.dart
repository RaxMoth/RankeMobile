import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/shell/app_shell.dart';
import '../../features/lists/presentation/discover_screen.dart';
import '../../features/lists/presentation/home_screen.dart';
import '../../features/lists/presentation/list_detail_screen.dart';
import '../../features/lists/presentation/create_list_sheet.dart';
import '../../features/lists/presentation/invite_preview_screen.dart';
import '../../features/lists/presentation/manage_members_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// App Router Configuration
final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // Shell with bottom nav: HOME / CREATE / PROFILE
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/discover',
            name: 'discover',
            builder: (context, state) => const DiscoverScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/create',
            name: 'create',
            builder: (context, state) => const CreateListScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ]),
      ],
    ),
    // Auth routes (no bottom nav)
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // Push routes (overlay on top of shell)
    GoRoute(
      path: '/lists/:id',
      name: 'listDetail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => ListDetailScreen(
        listId: state.pathParameters['id']!,
      ),
      routes: [
        GoRoute(
          path: 'members',
          name: 'manageMembers',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => ManageMembersScreen(
            listId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/invite/:token',
      name: 'invitePreview',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => InvitePreviewScreen(
        token: state.pathParameters['token']!,
      ),
    ),
  ],
  redirect: (context, state) {
    // TODO: Add auth guard redirect logic
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Route not found: ${state.uri}'),
    ),
  ),
);
