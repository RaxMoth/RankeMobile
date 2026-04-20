enum AppEnvironment { dev, staging, production }

/// Runtime configuration injected via --dart-define.
///
/// Example:
/// flutter run --dart-define=APP_ENV=staging --dart-define=API_BASE_URL=https://api.ranke.app
abstract class AppConfig {
  static const String _appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );
  static const String _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );
  static const String _appDisplayName = String.fromEnvironment(
    'APP_DISPLAY_NAME',
    defaultValue: 'Apex',
  );
  static const String _appVersionLabel = String.fromEnvironment(
    'APP_VERSION_LABEL',
    defaultValue: 'RANKED v1.1.0',
  );
  static const String _privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://example.com/privacy',
  );
  static const String _termsOfServiceUrl = String.fromEnvironment(
    'TERMS_OF_SERVICE_URL',
    defaultValue: 'https://example.com/terms',
  );
  static const String _supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'support@example.com',
  );

  static AppEnvironment get environment {
    switch (_appEnv.toLowerCase()) {
      case 'production':
      case 'prod':
        return AppEnvironment.production;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.dev;
    }
  }

  static bool get isProduction => environment == AppEnvironment.production;
  static bool get isStaging => environment == AppEnvironment.staging;

  static String get apiBaseUrl => _apiBaseUrl;
  static String get appDisplayName => _appDisplayName;
  static String get appVersionLabel => _appVersionLabel;
  static String get privacyPolicyUrl => _privacyPolicyUrl;
  static String get termsOfServiceUrl => _termsOfServiceUrl;
  static String get supportEmail => _supportEmail;
}
