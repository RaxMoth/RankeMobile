import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/lists/presentation/home_screen.dart';
import '../../features/lists/presentation/list_detail_screen.dart';
import '../../features/lists/presentation/create_list_sheet.dart';
import '../../features/lists/presentation/invite_preview_screen.dart';
import '../../features/lists/presentation/manage_members_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

/// App Router Configuration
final goRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
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
      path: '/create',
      name: 'create',
      builder: (context, state) => const CreateListScreen(),
    ),
    GoRoute(
      path: '/lists/:id',
      name: 'listDetail',
      builder: (context, state) => ListDetailScreen(
        listId: state.pathParameters['id']!,
      ),
      routes: [
        GoRoute(
          path: 'members',
          name: 'manageMembers',
          builder: (context, state) => ManageMembersScreen(
            listId: state.pathParameters['id']!,
          ),
        ),
      ],
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
