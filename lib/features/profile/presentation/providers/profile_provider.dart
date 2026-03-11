import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../../auth/domain/entities/user.dart';

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, User?>(ProfileNotifier.new);

class ProfileNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final result = await GetIt.instance<AuthRepository>().getCurrentUser();
    return result.fold(
      (_) => null,
      (user) => user,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
