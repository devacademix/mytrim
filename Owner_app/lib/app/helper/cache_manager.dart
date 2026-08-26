import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Centralized Cache Manager
/// Handles caching of API responses with TTL (Time To Live) support
/// 
/// Usage:
/// ```dart
/// // Store data
/// await CacheManager.instance.set('categories', data, duration: Duration(hours: 24));
/// 
/// // Retrieve data
/// var cachedData = await CacheManager.instance.get('categories');
/// 
/// // Check if valid
/// bool isValid = await CacheManager.instance.isValid('categories');
/// 
/// // Clear specific cache
/// await CacheManager.instance.clear('categories');
/// 
/// // Clear all cache
/// await CacheManager.instance.clearAll();
/// ```
class CacheManager {
  static CacheManager? _instance;
  static SharedPreferences? _prefs;

  // Private constructor
  CacheManager._();

  // Singleton instance
  static CacheManager get instance {
    _instance ??= CacheManager._();
    return _instance!;
  }

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Cache key prefixes
  static const String _cachePrefix = 'cache_';
  static const String _timestampPrefix = 'cache_timestamp_';

  /// Store data in cache with optional TTL
  /// 
  /// [key] - Unique identifier for cached data
  /// [data] - Data to cache (will be JSON encoded)
  /// [duration] - Cache validity duration (default: 1 hour)
  Future<bool> set(
    String key,
    dynamic data, {
    Duration duration = const Duration(hours: 1),
  }) async {
    try {
      await init();

      // Encode data to JSON string
      final String jsonData = jsonEncode(data);

      // Store data
      final bool dataStored = await _prefs!.setString('$_cachePrefix$key', jsonData);

      // Store timestamp
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      final bool timestampStored = await _prefs!.setInt('$_timestampPrefix$key', timestamp);

      // Store duration (in seconds)
      final bool durationStored = await _prefs!.setInt('${_timestampPrefix}duration_$key', duration.inSeconds);

      if (kDebugMode && dataStored && timestampStored && durationStored) {
        print('📦 Cache SET: $key (valid for ${duration.inMinutes} minutes)');
      }

      return dataStored && timestampStored && durationStored;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Cache SET Error for $key: $e');
      }
      return false;
    }
  }

  /// Retrieve data from cache if valid
  /// 
  /// Returns null if:
  /// - Cache doesn't exist
  /// - Cache has expired
  /// - Data is corrupted
  Future<dynamic> get(String key) async {
    try {
      await init();

      // Check if cache exists and is valid
      if (!await isValid(key)) {
        if (kDebugMode) {
          print('📦 Cache MISS: $key (expired or not found)');
        }
        return null;
      }

      // Retrieve data
      final String? jsonData = _prefs!.getString('$_cachePrefix$key');
      if (jsonData == null) return null;

      // Decode JSON
      final dynamic data = jsonDecode(jsonData);

      if (kDebugMode) {
        print('📦 Cache HIT: $key');
      }

      return data;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Cache GET Error for $key: $e');
      }
      // Clear corrupted cache
      await clear(key);
      return null;
    }
  }

  /// Check if cache exists and is still valid
  Future<bool> isValid(String key) async {
    try {
      await init();

      // Check if data exists
      if (!_prefs!.containsKey('$_cachePrefix$key')) {
        return false;
      }

      // Get timestamp
      final int? timestamp = _prefs!.getInt('$_timestampPrefix$key');
      if (timestamp == null) return false;

      // Get duration
      final int? durationSeconds = _prefs!.getInt('${_timestampPrefix}duration_$key');
      if (durationSeconds == null) return false;

      // Check if expired
      final DateTime cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final Duration duration = Duration(seconds: durationSeconds);
      final DateTime expiryTime = cachedTime.add(duration);

      final bool isValid = DateTime.now().isBefore(expiryTime);

      if (!isValid && kDebugMode) {
        final Duration timeSinceExpiry = DateTime.now().difference(expiryTime);
        print('📦 Cache EXPIRED: $key (expired ${timeSinceExpiry.inMinutes} minutes ago)');
      }

      return isValid;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Cache VALID Check Error for $key: $e');
      }
      return false;
    }
  }

  /// Get cached data or fetch from source if invalid
  /// 
  /// [key] - Cache key
  /// [fetchFunction] - Function to call if cache is invalid
  /// [duration] - Cache validity duration
  Future<dynamic> getOrFetch(
    String key,
    Future<dynamic> Function() fetchFunction, {
    Duration duration = const Duration(hours: 1),
  }) async {
    // Try to get from cache first
    final cachedData = await get(key);
    if (cachedData != null) {
      return cachedData;
    }

    if (kDebugMode) {
      print('📦 Cache FETCH: $key (fetching fresh data)');
    }

    // Fetch fresh data
    final freshData = await fetchFunction();

    // Cache the fresh data
    if (freshData != null) {
      await set(key, freshData, duration: duration);
    }

    return freshData;
  }

  /// Clear specific cache entry
  Future<bool> clear(String key) async {
    try {
      await init();

      final bool dataCleared = await _prefs!.remove('$_cachePrefix$key');
      final bool timestampCleared = await _prefs!.remove('$_timestampPrefix$key');
      final bool durationCleared = await _prefs!.remove('${_timestampPrefix}duration_$key');

      if (kDebugMode && dataCleared) {
        print('🗑️ Cache CLEARED: $key');
      }

      return dataCleared && timestampCleared && durationCleared;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Cache CLEAR Error for $key: $e');
      }
      return false;
    }
  }

  /// Clear all cache entries
  Future<bool> clearAll() async {
    try {
      await init();

      // Get all keys
      final Set<String> keys = _prefs!.getKeys();

      // Filter cache-related keys
      final List<String> cacheKeys = keys
          .where((key) =>
              key.startsWith(_cachePrefix) ||
              key.startsWith(_timestampPrefix))
          .toList();

      // Remove all cache keys
      for (String key in cacheKeys) {
        await _prefs!.remove(key);
      }

      if (kDebugMode) {
        print('🗑️ Cache CLEARED ALL: ${cacheKeys.length} entries');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Cache CLEAR ALL Error: $e');
      }
      return false;
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getStats() async {
    try {
      await init();

      final Set<String> keys = _prefs!.getKeys();
      final List<String> cacheDataKeys = keys
          .where((key) => key.startsWith(_cachePrefix))
          .toList();

      int validCount = 0;
      int expiredCount = 0;

      for (String fullKey in cacheDataKeys) {
        final String key = fullKey.substring(_cachePrefix.length);
        if (await isValid(key)) {
          validCount++;
        } else {
          expiredCount++;
        }
      }

      return {
        'total': cacheDataKeys.length,
        'valid': validCount,
        'expired': expiredCount,
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Cache STATS Error: $e');
      }
      return {'total': 0, 'valid': 0, 'expired': 0};
    }
  }

  /// Clean up expired cache entries
  Future<int> cleanupExpired() async {
    try {
      await init();

      final Set<String> keys = _prefs!.getKeys();
      final List<String> cacheDataKeys = keys
          .where((key) => key.startsWith(_cachePrefix))
          .toList();

      int cleanedCount = 0;

      for (String fullKey in cacheDataKeys) {
        final String key = fullKey.substring(_cachePrefix.length);
        if (!await isValid(key)) {
          await clear(key);
          cleanedCount++;
        }
      }

      if (kDebugMode && cleanedCount > 0) {
        print('🧹 Cache CLEANUP: Removed $cleanedCount expired entries');
      }

      return cleanedCount;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Cache CLEANUP Error: $e');
      }
      return 0;
    }
  }
}

/// Predefined cache keys for consistency
class CacheKeys {
  // Static data (long TTL - 24 hours)
  static const String categories = 'categories';
  static const String cities = 'cities';
  static const String activeCities = 'active_cities';
  static const String productCategories = 'product_categories';
  
  // Settings (medium TTL - 1 hour)
  static const String appSettings = 'app_settings';
  
  // User data (short TTL - 30 minutes)
  static const String profile = 'profile';
  static const String salonInfo = 'salon_info';
  static const String individualInfo = 'individual_info';
  
  // Lists (short TTL - 15 minutes)
  static const String appointments = 'appointments';
  static const String services = 'services';
  static const String products = 'products';
  static const String specialists = 'specialists';
  static const String packages = 'packages';
  static const String timeSlots = 'time_slots';
  
  // Orders (short TTL - 10 minutes)
  static const String appointmentOrders = 'appointment_orders';
  static const String productOrders = 'product_orders';
  
  // Analytics (medium TTL - 30 minutes)
  static const String appointmentStats = 'appointment_stats';
  static const String productStats = 'product_stats';
  static const String monthlyStats = 'monthly_stats';
  static const String yearlyStats = 'yearly_stats';
  
  // Chat (very short TTL - 5 minutes)
  static const String chatRooms = 'chat_rooms';
  static const String chatMessages = 'chat_messages';
}

/// Predefined cache durations for different data types
class CacheDurations {
  // Static data that rarely changes
  static const Duration veryLong = Duration(hours: 24);
  static const Duration long = Duration(hours: 12);
  
  // Semi-static data
  static const Duration medium = Duration(hours: 1);
  static const Duration short = Duration(minutes: 30);
  
  // Frequently changing data
  static const Duration veryShort = Duration(minutes: 15);
  static const Duration realtime = Duration(minutes: 5);
}
