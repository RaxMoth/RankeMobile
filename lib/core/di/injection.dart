import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/auth/data/auth_remote_data_source.dart';
import '../../features/auth/data/auth_repository_impl.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/domain/use_cases/apple_sign_in_use_case.dart';
import '../../features/auth/domain/use_cases/login_use_case.dart';
import '../../features/auth/domain/use_cases/logout_use_case.dart';
import '../../features/auth/domain/use_cases/register_use_case.dart';
import '../../features/lists/data/lists_remote_data_source.dart';
import '../../features/lists/data/lists_repository_impl.dart';
import '../../features/lists/domain/lists_repository.dart';
import '../../features/lists/domain/use_cases/create_list_use_case.dart';
import '../../features/lists/domain/use_cases/get_list_detail_use_case.dart';
import '../../features/lists/domain/use_cases/get_lists_use_case.dart';
import '../../features/lists/domain/use_cases/get_invite_preview_use_case.dart';
import '../../features/lists/domain/use_cases/join_by_invite_use_case.dart';
import '../../features/entries/data/entries_remote_data_source.dart';
import '../../features/entries/data/entries_repository_impl.dart';
import '../../features/entries/domain/entries_repository.dart';
import '../../features/entries/domain/use_cases/submit_entry_use_case.dart';

final sl = GetIt.instance;

void setupDI() {
  // Core
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(secureStorage: sl<FlutterSecureStorage>()),
  );

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<ApiClient>(), sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerFactory(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => AppleSignInUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => LogoutUseCase(sl<AuthRepository>()));

  // Lists
  sl.registerLazySingleton<ListsRemoteDataSource>(
    () => ListsRemoteDataSource(sl<ApiClient>()),
  );
  sl.registerLazySingleton<ListsRepository>(
    () => ListsRepositoryImpl(sl<ListsRemoteDataSource>()),
  );
  sl.registerFactory(() => GetListsUseCase(sl<ListsRepository>()));
  sl.registerFactory(() => GetListDetailUseCase(sl<ListsRepository>()));
  sl.registerFactory(() => CreateListUseCase(sl<ListsRepository>()));
  sl.registerFactory(() => GetInvitePreviewUseCase(sl<ListsRepository>()));
  sl.registerFactory(() => JoinByInviteUseCase(sl<ListsRepository>()));

  // Entries
  sl.registerLazySingleton<EntriesRemoteDataSource>(
    () => EntriesRemoteDataSource(sl<ApiClient>()),
  );
  sl.registerLazySingleton<EntriesRepository>(
    () => EntriesRepositoryImpl(sl<EntriesRemoteDataSource>()),
  );
  sl.registerFactory(() => SubmitEntryUseCase(sl<EntriesRepository>()));
}
