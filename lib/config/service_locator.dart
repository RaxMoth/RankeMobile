import 'package:get_it/get_it.dart';
import '../shared/services/api_service.dart';
import '../shared/services/connectivity_service.dart';
import '../shared/services/local_storage_service.dart';
import '../shared/services/logger_service.dart';

final getIt = GetIt.instance;

/// Setup Service Locator
Future<void> setupServiceLocator() async {
  // Logger service
  getIt.registerSingleton<LoggerService>(LoggerService());

  // Initialize and register LocalStorageService
  final localStorage = LocalStorageService();
  await localStorage.initialize();
  getIt.registerSingleton<LocalStorageService>(localStorage);

  // API service
  getIt.registerSingleton<ApiService>(ApiService());

  // Connectivity service
  getIt.registerSingleton<ConnectivityService>(ConnectivityService());

  LoggerService.info('Service locator setup completed');
}
