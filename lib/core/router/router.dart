import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/presentation/activity_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/lists/presentation/create_list_sheet.dart';
import '../../features/lists/presentation/discover_screen.dart';
import '../../features/lists/presentation/home_screen.dart';
import '../../features/lists/presentation/invite_preview_screen.dart';
import '../../features/lists/presentation/list_detail_screen.dart';
import '../../features/lists/presentation/manage_members_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/profile/presentation/user_profile_screen.dart';
import '../../features/shell/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

const _publicPaths = {'/login', '/register', '/onboarding'};

/// Whether onboarding has been completed.
/// Loaded synchronously in main() and overridden via ProviderScope.
/// Mutable so OnboardingScreen can mark it true after completion.
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// GoRouter provider with auth guard redirect.
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final onboardingDone = ref.watch(onboardingCompleteProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      // Shell with bottom nav: HOME / DISCOVER / ACTIVITY
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discover',
                name: 'discover',
                builder: (context, state) => const DiscoverScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activity',
                name: 'activity',
                builder: (context, state) => const ActivityScreen(),
              ),
            ],
          ),
        ],
      ),
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
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
        builder: (context, state) =>
            ListDetailScreen(listId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'members',
            name: 'manageMembers',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) =>
                ManageMembersScreen(listId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/invite/:token',
        name: 'invitePreview',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            InvitePreviewScreen(token: state.pathParameters['token']!),
      ),
      GoRoute(
        path: '/users/:id',
        name: 'userProfile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            UserProfileScreen(userId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/create',
        name: 'create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateListScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isPublicRoute = _publicPaths.contains(state.matchedLocation);
      final isOnboarding = state.matchedLocation == '/onboarding';

      // First launch: show onboarding
      if (!onboardingDone && !isOnboarding) return '/onboarding';

      // Not logged in and trying to access protected route → login
      if (!isLoggedIn && !isPublicRoute) return '/login';

      // Logged in and on auth/public page → home
      // But don't redirect away from onboarding until it's completed
      if (isLoggedIn && isPublicRoute && (onboardingDone || !isOnboarding)) {
        return '/home';
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('Route not found: ${state.uri}'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('GO HOME'),
            ),
          ],
        ),
      ),
    ),
  );
});
