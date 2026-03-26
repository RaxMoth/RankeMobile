import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/dev/dev_config.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/apple_sign_in_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // In dev mode, auto-login with mock user
    if (DevConfig.useDevMode) {
      return const User(
        id: 'dev-user-001',
        email: 'max@apex.dev',
        displayName: 'Max Roth',
      );
    }
    // TODO: Check stored token and load current user
    return null;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await GetIt.instance<LoginUseCase>().call(
      email: email,
      password: password,
    );
    state = result.fold(
      (error) => AsyncError(error, StackTrace.current),
      (user) => AsyncData(user),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    final result = await GetIt.instance<RegisterUseCase>().call(
      email: email,
      password: password,
      displayName: displayName,
    );
    state = result.fold(
      (error) => AsyncError(error, StackTrace.current),
      (user) => AsyncData(user),
    );
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null) {
        state = AsyncError('No identity token received', StackTrace.current);
        return;
      }

      final fullName = [
        credential.givenName,
        credential.familyName,
      ].where((n) => n != null).join(' ');

      final result = await GetIt.instance<AppleSignInUseCase>().call(
        identityToken: identityToken,
        fullName: fullName.isEmpty ? null : fullName,
      );

      state = result.fold(
        (error) => AsyncError(error, StackTrace.current),
        (user) => AsyncData(user),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    await GetIt.instance<LogoutUseCase>().call();
    state = const AsyncData(null);
  }
}
