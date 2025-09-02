class AppConstants {
  // App Info
  static const String appName = 'DICUMÊ';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'App educacional nutricional para pessoas com diabetes tipo 2 em Imperatriz-MA';

  // Environment
  static const bool isDevelopment = bool.fromEnvironment(
    'DEBUG',
    defaultValue: true,
  );

  static const String apiBaseDevUrl = 'http://189.90.44.226:5050/api/v1';
  static const String apiBaseUrl = 'http://189.90.44.226:5050/api/v1';
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String alimentosCacheKey = 'alimentos_cache';
  static const String lastSyncKey = 'last_sync';
  // Database
  static const String databaseName = 'dicume_database.db';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPhoneLength = 15;
  static const int smsCodeLength = 6;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache
  static const Duration cacheValidDuration = Duration(hours: 24);
  static const Duration syncRetryInterval = Duration(minutes: 5);

  // UI
  static const double buttonHeight = 56.0;
  static const double cardElevation = 2.0;
  static const double borderRadius = 12.0;
  static const double minTouchTarget = 48.0;
}
