import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_remote_data_source.dart';
import '../../features/auth/data/auth_repository_impl.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/domain/use_cases/apple_sign_in_use_case.dart';
import '../../features/auth/domain/use_cases/login_use_case.dart';
import '../../features/auth/domain/use_cases/logout_use_case.dart';
import '../../features/auth/domain/use_cases/register_use_case.dart';
import '../../features/entries/data/entries_remote_data_source.dart';
import '../../features/entries/data/entries_repository_impl.dart';
import '../../features/entries/domain/entries_repository.dart';
import '../../features/entries/domain/use_cases/approve_entry_use_case.dart';
import '../../features/entries/domain/use_cases/get_pending_entries_use_case.dart';
import '../../features/entries/domain/use_cases/reject_entry_use_case.dart';
import '../../features/entries/domain/use_cases/submit_entry_use_case.dart';
import '../../features/lists/data/lists_remote_data_source.dart';
import '../../features/lists/data/lists_repository_impl.dart';
import '../../features/lists/domain/lists_repository.dart';
import '../../features/lists/domain/use_cases/create_list_use_case.dart';
import '../../features/lists/domain/use_cases/get_invite_preview_use_case.dart';
import '../../features/lists/domain/use_cases/get_list_detail_use_case.dart';
import '../../features/lists/domain/use_cases/get_lists_use_case.dart';
import '../../features/lists/domain/use_cases/join_by_invite_use_case.dart';
import '../../features/lists/domain/use_cases/search_public_lists_use_case.dart';
import '../dev/dev_config.dart';
import '../dev/mock_auth_repository.dart';
import '../dev/mock_entries_repository.dart';
import '../dev/mock_lists_repository.dart';
import '../network/api_client.dart';

final getIt = GetIt.instance;

/// Setup dependency injection — runs before runApp
Future<void> setupDI() async {
  // Idempotent setup prevents duplicate registration crashes when tests
  // or debug sessions reinitialize the graph.
  await getIt.reset();

  if (DevConfig.useDevMode) {
    _registerDevMode();
  } else {
    _registerProductionMode();
  }

  // Use cases (same for both modes — they depend on repository interfaces)
  _registerUseCases();
}

void _registerDevMode() {
  // Mock repositories with in-memory seed data
  final mockListsRepo = MockListsRepository();
  getIt.registerSingleton<AuthRepository>(MockAuthRepository());
  getIt.registerSingleton<ListsRepository>(mockListsRepo);
  getIt.registerSingleton<EntriesRepository>(
    MockEntriesRepository(mockListsRepo),
  );
}

void _registerProductionMode() {
  // Core
  getIt.registerSingleton<ApiClient>(ApiClient());

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  // Lists
  getIt.registerLazySingleton<ListsRemoteDataSource>(
    () => ListsRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<ListsRepository>(
    () => ListsRepositoryImpl(getIt<ListsRemoteDataSource>()),
  );

  // Entries
  getIt.registerLazySingleton<EntriesRemoteDataSource>(
    () => EntriesRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<EntriesRepository>(
    () => EntriesRepositoryImpl(getIt<EntriesRemoteDataSource>()),
  );
}

void _registerUseCases() {
  // Auth use cases
  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => AppleSignInUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => LogoutUseCase(getIt<AuthRepository>()));

  // Lists use cases
  getIt.registerFactory(() => GetListsUseCase(getIt<ListsRepository>()));
  getIt.registerFactory(() => GetListDetailUseCase(getIt<ListsRepository>()));
  getIt.registerFactory(() => CreateListUseCase(getIt<ListsRepository>()));
  getIt.registerFactory(
    () => GetInvitePreviewUseCase(getIt<ListsRepository>()),
  );
  getIt.registerFactory(() => JoinByInviteUseCase(getIt<ListsRepository>()));
  getIt.registerFactory(
    () => SearchPublicListsUseCase(getIt<ListsRepository>()),
  );

  // Entries use cases
  getIt.registerFactory(() => SubmitEntryUseCase(getIt<EntriesRepository>()));
  getIt.registerFactory(() => ApproveEntryUseCase(getIt<EntriesRepository>()));
  getIt.registerFactory(() => RejectEntryUseCase(getIt<EntriesRepository>()));
  getIt.registerFactory(
    () => GetPendingEntriesUseCase(getIt<EntriesRepository>()),
  );
}
