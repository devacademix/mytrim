import 'package:owner/app/config/app_config.dart';

/// Environment Configuration
/// Now uses dynamic configuration based on build environment
/// 
/// IMPORTANT: DO NOT hardcode URLs or API keys here anymore!
/// Use AppConfig for environment-specific values.
/// 
/// To build for different environments:
/// - Development: flutter run
/// - Staging: flutter run --dart-define=ENV=staging --dart-define=MAPS_KEY=your_key
/// - Production: flutter run --dart-define=ENV=prod --dart-define=MAPS_KEY=your_key
class Environments {
  static const String appName = 'Ultimate Owner Salon & Shop';
  static const String companyName = 'MyTrim';
  
  // Dynamic API Base URL based on environment
  static String get apiBaseURL => AppConfig.baseUrl;
  
  // Secure Google Maps API Key from build configuration
  static String get googleMapsKey => AppConfig.googleMapsKey;
  
  // Helper getters for environment checking
  static bool get isProduction => AppConfig.isProduction;
  static bool get isStaging => AppConfig.isStaging;
  static bool get isDevelopment => AppConfig.isDevelopment;
  static String get currentEnvironment => AppConfig.environment;
}
