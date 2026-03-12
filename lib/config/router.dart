import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/lists/presentation/home_screen.dart';
import '../features/lists/presentation/list_detail_screen.dart';
import '../features/lists/presentation/invite_preview_screen.dart';
import '../features/lists/presentation/manage_members_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.hasValue && authState.value != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isInviteRoute = state.matchedLocation.startsWith('/invite');

      if (isInviteRoute) return null;
      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      if (isLoggedIn && state.matchedLocation == '/') return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/home',
      ),
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
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/lists/:id',
        name: 'listDetail',
        builder: (context, state) => ListDetailScreen(
          listId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/lists/:id/members',
        name: 'manageMembers',
        builder: (context, state) => ManageMembersScreen(
          listId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/invite/:token',
        name: 'invitePreview',
        builder: (context, state) => InvitePreviewScreen(
          token: state.pathParameters['token']!,
        ),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(
        child: Text('Route not found: ${state.matchedLocation}'),
      ),
    ),
  );
});
