import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Retry Manager with Exponential Backoff
/// Automatically retries failed API calls with configurable attempts and delays
/// 
/// Usage:
/// ```dart
/// final response = await RetryManager.instance.retry(
///   () => apiService.getPrivate('appointments', token),
///   retries: 3,
///   onRetry: (attempt, delay) => print('Retry attempt $attempt after $delay ms'),
/// );
/// ```
class RetryManager {
  static RetryManager? _instance;
  
  // Private constructor
  RetryManager._();
  
  // Singleton instance
  static RetryManager get instance {
    _instance ??= RetryManager._();
    return _instance!;
  }

  /// Retry a function with exponential backoff
  /// 
  /// [function] - The async function to retry
  /// [retries] - Maximum number of retry attempts (default: 3)
  /// [delayFactor] - Base delay in milliseconds for exponential backoff (default: 1000ms)
  /// [maxDelay] - Maximum delay between retries (default: 10000ms)
  /// [retryIf] - Optional condition to determine if retry should happen
  /// [onRetry] - Optional callback called before each retry with attempt number and delay
  Future<T> retry<T>(
    Future<T> Function() function, {
    int retries = 3,
    int delayFactor = 1000,
    int maxDelay = 10000,
    bool Function(dynamic error)? retryIf,
    void Function(int attempt, int delay)? onRetry,
  }) async {
    int attempt = 0;
    
    while (true) {
      try {
        return await function();
      } catch (error) {
        attempt++;
        
        // Check if we should retry
        final bool shouldRetry = retryIf?.call(error) ?? _shouldRetryByDefault(error);
        
        if (attempt > retries || !shouldRetry) {
          if (kDebugMode) {
            print('❌ Retry FAILED after $attempt attempts: $error');
          }
          rethrow;
        }
        
        // Calculate delay with exponential backoff
        final int delay = _calculateDelay(attempt, delayFactor, maxDelay);
        
        if (kDebugMode) {
          print('🔄 Retry attempt $attempt/$retries after ${delay}ms delay: $error');
        }
        
        // Call onRetry callback if provided
        onRetry?.call(attempt, delay);
        
        // Wait before retrying
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
  }

  /// Retry API call with Response validation
  /// 
  /// Specifically designed for GetX Response objects
  /// Retries on network errors and server errors (5xx)
  Future<Response> retryApiCall(
    Future<Response> Function() apiCall, {
    int retries = 3,
    int delayFactor = 1000,
    int maxDelay = 10000,
    void Function(int attempt, int delay)? onRetry,
  }) async {
    return await retry<Response>(
      apiCall,
      retries: retries,
      delayFactor: delayFactor,
      maxDelay: maxDelay,
      retryIf: (error) {
        // Retry on exceptions
        if (error is! Response) {
          return true;
        }
        
        // Retry on these status codes
        final response = error as Response;
        return _shouldRetryResponse(response);
      },
      onRetry: onRetry,
    );
  }

  /// Retry API call with custom success validation
  /// 
  /// [apiCall] - The API function to call
  /// [validateSuccess] - Function to validate if response is successful
  /// [retries] - Maximum retry attempts
  /// [delayFactor] - Base delay for exponential backoff
  /// [onRetry] - Callback before each retry
  Future<Response> retryUntilSuccess(
    Future<Response> Function() apiCall, {
    required bool Function(Response) validateSuccess,
    int retries = 3,
    int delayFactor = 1000,
    int maxDelay = 10000,
    void Function(int attempt, int delay)? onRetry,
  }) async {
    int attempt = 0;
    
    while (true) {
      attempt++;
      
      try {
        final Response response = await apiCall();
        
        // Check if response is successful
        if (validateSuccess(response)) {
          if (kDebugMode && attempt > 1) {
            print('✅ Retry SUCCESS after $attempt attempts');
          }
          return response;
        }
        
        // Response not successful, check if we should retry
        if (attempt > retries || !_shouldRetryResponse(response)) {
          if (kDebugMode) {
            print('❌ Retry STOPPED after $attempt attempts (status: ${response.statusCode})');
          }
          return response;
        }
        
        // Calculate delay
        final int delay = _calculateDelay(attempt, delayFactor, maxDelay);
        
        if (kDebugMode) {
          print('🔄 Retry attempt $attempt/$retries after ${delay}ms (status: ${response.statusCode})');
        }
        
        // Call onRetry callback
        onRetry?.call(attempt, delay);
        
        // Wait before retrying
        await Future.delayed(Duration(milliseconds: delay));
        
      } catch (error) {
        if (attempt > retries) {
          if (kDebugMode) {
            print('❌ Retry FAILED after $attempt attempts: $error');
          }
          rethrow;
        }
        
        final int delay = _calculateDelay(attempt, delayFactor, maxDelay);
        
        if (kDebugMode) {
          print('🔄 Retry attempt $attempt/$retries after ${delay}ms: $error');
        }
        
        onRetry?.call(attempt, delay);
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
  }

  /// Calculate exponential backoff delay
  int _calculateDelay(int attempt, int delayFactor, int maxDelay) {
    // Exponential backoff: delay = delayFactor * (2 ^ (attempt - 1))
    // Example with delayFactor=1000:
    // Attempt 1: 1000ms (1s)
    // Attempt 2: 2000ms (2s)
    // Attempt 3: 4000ms (4s)
    // Attempt 4: 8000ms (8s)
    int delay = (delayFactor * (1 << (attempt - 1))).toInt();
    
    // Cap at maxDelay
    return delay > maxDelay ? maxDelay : delay;
  }

  /// Determine if error should trigger retry by default
  bool _shouldRetryByDefault(dynamic error) {
    final String errorString = error.toString().toLowerCase();
    
    // Retry on network-related errors
    return errorString.contains('socket') ||
        errorString.contains('timeout') ||
        errorString.contains('connection') ||
        errorString.contains('network') ||
        errorString.contains('unreachable');
  }

  /// Determine if Response status code should trigger retry
  bool _shouldRetryResponse(Response response) {
    final int? statusCode = response.statusCode;
    
    if (statusCode == null) return true;
    
    // Retry on network errors (status code 0 or 1)
    if (statusCode == 0 || statusCode == 1) return true;
    
    // Retry on server errors (5xx)
    if (statusCode >= 500 && statusCode < 600) return true;
    
    // Retry on request timeout
    if (statusCode == 408) return true;
    
    // Retry on too many requests (with backoff)
    if (statusCode == 429) return true;
    
    // Don't retry on client errors (4xx) except timeout and rate limit
    return false;
  }
}

/// Retry Configuration Presets
class RetryConfig {
  /// Quick retry for real-time operations
  /// 2 attempts, 500ms base delay
  static const RetryConfigData quick = RetryConfigData(
    retries: 2,
    delayFactor: 500,
    maxDelay: 2000,
  );
  
  /// Standard retry for most API calls
  /// 3 attempts, 1000ms base delay
  static const RetryConfigData standard = RetryConfigData(
    retries: 3,
    delayFactor: 1000,
    maxDelay: 5000,
  );
  
  /// Persistent retry for important operations
  /// 5 attempts, 1000ms base delay
  static const RetryConfigData persistent = RetryConfigData(
    retries: 5,
    delayFactor: 1000,
    maxDelay: 10000,
  );
  
  /// Aggressive retry for critical operations
  /// 7 attempts, 2000ms base delay
  static const RetryConfigData aggressive = RetryConfigData(
    retries: 7,
    delayFactor: 2000,
    maxDelay: 30000,
  );
  
  /// No retry (for operations that should fail fast)
  static const RetryConfigData none = RetryConfigData(
    retries: 0,
    delayFactor: 0,
    maxDelay: 0,
  );
}

/// Retry configuration data class
class RetryConfigData {
  final int retries;
  final int delayFactor;
  final int maxDelay;
  
  const RetryConfigData({
    required this.retries,
    required this.delayFactor,
    required this.maxDelay,
  });
}

/// Extension to add retry capability to Future<Response>
extension RetryExtension on Future<Response> Function() {
  /// Retry this API call with standard configuration
  Future<Response> withRetry({
    int retries = 3,
    int delayFactor = 1000,
    int maxDelay = 10000,
    void Function(int attempt, int delay)? onRetry,
  }) {
    return RetryManager.instance.retryApiCall(
      this,
      retries: retries,
      delayFactor: delayFactor,
      maxDelay: maxDelay,
      onRetry: onRetry,
    );
  }
  
  /// Retry with quick config
  Future<Response> withQuickRetry() {
    return RetryManager.instance.retryApiCall(
      this,
      retries: RetryConfig.quick.retries,
      delayFactor: RetryConfig.quick.delayFactor,
      maxDelay: RetryConfig.quick.maxDelay,
    );
  }
  
  /// Retry with persistent config
  Future<Response> withPersistentRetry() {
    return RetryManager.instance.retryApiCall(
      this,
      retries: RetryConfig.persistent.retries,
      delayFactor: RetryConfig.persistent.delayFactor,
      maxDelay: RetryConfig.persistent.maxDelay,
    );
  }
}
