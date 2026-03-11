// GetIt registration — runs before runApp
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register your services, repositories, and data sources here
  // Example:
  // getIt.registerLazySingleton<ApiClient>(() => ApiClient());
}
