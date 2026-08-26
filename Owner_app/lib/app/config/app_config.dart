import 'package:flutter/foundation.dart';

/// Application Configuration
/// Manages environment-specific settings (dev, staging, production)
/// 
/// Usage:
/// - Development: flutter run --dart-define=ENV=dev
/// - Staging: flutter run --dart-define=ENV=staging
/// - Production: flutter run --dart-define=ENV=prod --dart-define=MAPS_KEY=your_key
class AppConfig {
  // Get environment from build-time constant
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  // Check if running in production
  static bool get isProduction => environment == 'prod';
  static bool get isStaging => environment == 'staging';
  static bool get isDevelopment => environment == 'dev';

  // Base URLs for different environments
  static const Map<String, String> _baseUrls = {
    'dev': 'http://localhost:8001/',
    'staging': 'https://api.mytrim.in/',
    'prod': 'https://api.mytrim.in/',
  };

  // Get base URL for current environment
  static String get baseUrl {
    final url = _baseUrls[environment];
    if (url == null) {
      if (kDebugMode) {
        print('⚠️ Unknown environment: $environment, falling back to dev');
      }
      return _baseUrls['dev']!;
    }
    return url;
  }

  // Google Maps API Key from build-time constant
  static const String _mapsKey = String.fromEnvironment(
    'MAPS_KEY',
    defaultValue: '',
  );

  static String get googleMapsKey {
    if (_mapsKey.isEmpty && isProduction) {
      throw Exception('⚠️ CRITICAL: Google Maps API key not provided for production build!');
    }
    if (_mapsKey.isEmpty) {
      if (kDebugMode) {
        print('⚠️ WARNING: Google Maps API key not provided, using default (dev only)');
      }
      // Default key for development only - REPLACE THIS WITH YOUR DEV KEY
      return 'AIzaSyCoIPy2P85k12nzjIT5xFIv62FVnBYErBA';
    }
    return _mapsKey;
  }

  // API timeout configuration
  static int get apiTimeout {
    switch (environment) {
      case 'prod':
        return 30; // 30 seconds for production
      case 'staging':
        return 45; // 45 seconds for staging (more time for debugging)
      case 'dev':
        return 60; // 60 seconds for development
      default:
        return 30;
    }
  }

  // Enable/disable debug logs
  static bool get enableLogs {
    return !isProduction;
  }

  // Print configuration summary (debug only)
  static void printConfig() {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📱 Owner App Configuration');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🌍 Environment: $environment');
      print('🔗 Base URL: $baseUrl');
      print('🗺️  Maps Key: ${_mapsKey.isEmpty ? "Using default (dev)" : "Provided ✓"}');
      print('⏱️  API Timeout: ${apiTimeout}s');
      print('📝 Debug Logs: ${enableLogs ? "Enabled" : "Disabled"}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }
}
