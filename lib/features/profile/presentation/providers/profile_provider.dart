import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../lists/domain/lists_repository.dart';
import '../../domain/entities/user_profile.dart';

/// Provider for viewing another user's public profile.
final userProfileProvider = AsyncNotifierProvider.family<UserProfileNotifier,
    UserProfile, String>(UserProfileNotifier.new);

class UserProfileNotifier extends FamilyAsyncNotifier<UserProfile, String> {
  @override
  Future<UserProfile> build(String arg) async {
    final repo = GetIt.instance<ListsRepository>();
    final result = await repo.getUserProfile(arg);
    return result.fold(
      (error) => throw error,
      (profile) => profile,
    );
  }
}
