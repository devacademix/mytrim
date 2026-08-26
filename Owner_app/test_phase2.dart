// Phase 2 Testing Script
// Run this file to test all stability improvements

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/helper/cache_manager.dart';
import 'package:owner/app/helper/error_handler.dart';
import 'package:owner/app/helper/retry_manager.dart';
import 'package:owner/app/helper/loading_manager.dart';
import 'package:owner/app/helper/connectivity_manager.dart';
import 'package:owner/app/helper/skeleton_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🧪 Starting Phase 2 Stability Tests...\n');
  
  // Initialize managers
  await CacheManager.instance.init();
  await ConnectivityManager.instance.init();
  
  // Run tests
  await testCacheManager();
  await testErrorHandler();
  await testRetryManager();
  await testLoadingManager();
  await testConnectivityManager();
  testSkeletonLoader();
  
  print('\n✅ All Phase 2 tests completed!');
}

/// Test 1: Cache Manager
Future<void> testCacheManager() async {
  print('📦 Testing Cache Manager...');
  
  try {
    // Test set and get
    await CacheManager.instance.set('test_key', {'name': 'John', 'age': 30});
    var data = await CacheManager.instance.get('test_key');
    assert(data != null, 'Cache data should not be null');
    print('  ✓ Set and get working');
    
    // Test TTL expiry
    await CacheManager.instance.set('short_cache', 'test', duration: Duration(seconds: 2));
    await Future.delayed(Duration(seconds: 3));
    var expired = await CacheManager.instance.get('short_cache');
    assert(expired == null, 'Expired cache should be null');
    print('  ✓ TTL expiry working');
    
    // Test get-or-fetch
    int fetchCount = 0;
    var result1 = await CacheManager.instance.getOrFetch(
      'fetch_test',
      () async {
        fetchCount++;
        return 'Fresh data';
      },
      duration: Duration(minutes: 1),
    );
    var result2 = await CacheManager.instance.getOrFetch(
      'fetch_test',
      () async {
        fetchCount++;
        return 'Fresh data';
      },
      duration: Duration(minutes: 1),
    );
    assert(fetchCount == 1, 'Should only fetch once');
    print('  ✓ Get-or-fetch working');
    
    // Test statistics
    var stats = await CacheManager.instance.getStats();
    print('  ✓ Statistics: ${stats['total']} total, ${stats['valid']} valid');
    
    // Test cleanup
    int cleaned = await CacheManager.instance.cleanupExpired();
    print('  ✓ Cleaned $cleaned expired entries');
    
    print('  ✅ Cache Manager tests passed!\n');
  } catch (e) {
    print('  ❌ Cache Manager test failed: $e\n');
  }
}

/// Test 2: Error Handler
Future<void> testErrorHandler() async {
  print('🚨 Testing Error Handler...');
  
  try {
    // Test error type detection
    var response400 = Response(statusCode: 400, body: {'message': 'Bad request'});
    assert(response400.errorType == ErrorType.badRequest, 'Should detect bad request');
    
    var response500 = Response(statusCode: 500, body: {'message': 'Server error'});
    assert(response500.errorType == ErrorType.server, 'Should detect server error');
    
    var response0 = Response(statusCode: 0);
    assert(response0.errorType == ErrorType.network, 'Should detect network error');
    print('  ✓ Error type detection working');
    
    // Test response extensions
    assert(Response(statusCode: 200).isSuccess == true, 'Should detect success');
    assert(Response(statusCode: 404).isError == true, 'Should detect error');
    print('  ✓ Response extensions working');
    
    print('  ✅ Error Handler tests passed!\n');
  } catch (e) {
    print('  ❌ Error Handler test failed: $e\n');
  }
}

/// Test 3: Retry Manager
Future<void> testRetryManager() async {
  print('🔄 Testing Retry Manager...');
  
  try {
    // Test basic retry
    int attempts = 0;
    var result = await RetryManager.instance.retry(
      () async {
        attempts++;
        if (attempts < 3) throw Exception('Temporary failure');
        return 'Success';
      },
      retries: 5,
      delayFactor: 100, // Short delay for testing
    );
    assert(result == 'Success', 'Should succeed after retries');
    assert(attempts == 3, 'Should take 3 attempts');
    print('  ✓ Basic retry working (succeeded after $attempts attempts)');
    
    // Test max retries
    attempts = 0;
    try {
      await RetryManager.instance.retry(
        () async {
          attempts++;
          throw Exception('Always fails');
        },
        retries: 3,
        delayFactor: 100,
      );
      assert(false, 'Should have thrown exception');
    } catch (e) {
      assert(attempts == 4, 'Should attempt initial + 3 retries'); // 1 initial + 3 retries
      print('  ✓ Max retries working (stopped after $attempts attempts)');
    }
    
    // Test retry conditions
    var networkResponse = Response(statusCode: 0);
    bool shouldRetry = RetryManager.instance._shouldRetryResponse(networkResponse);
    assert(shouldRetry == true, 'Should retry on network error');
    
    var clientResponse = Response(statusCode: 400);
    shouldRetry = RetryManager.instance._shouldRetryResponse(clientResponse);
    assert(shouldRetry == false, 'Should not retry on client error');
    print('  ✓ Retry conditions working');
    
    print('  ✅ Retry Manager tests passed!\n');
  } catch (e) {
    print('  ❌ Retry Manager test failed: $e\n');
  }
}

/// Test 4: Loading Manager
Future<void> testLoadingManager() async {
  print('⏳ Testing Loading Manager...');
  
  try {
    // Test state tracking
    assert(LoadingManager.isLoading == false, 'Should not be loading initially');
    
    // Test execute wrapper
    var result = await LoadingManager.execute(
      () async {
        await Future.delayed(Duration(milliseconds: 100));
        return 'Done';
      },
      message: 'Testing...',
    );
    assert(result == 'Done', 'Should return result');
    assert(LoadingManager.isLoading == false, 'Should hide after completion');
    print('  ✓ Execute wrapper working');
    
    // Test error handling
    var errorResult = await LoadingManager.executeWithErrorHandling(
      () async {
        throw Exception('Test error');
      },
      message: 'Loading...',
    );
    assert(errorResult == null, 'Should return null on error');
    print('  ✓ Error handling working');
    
    print('  ✅ Loading Manager tests passed!\n');
  } catch (e) {
    print('  ❌ Loading Manager test failed: $e\n');
  }
}

/// Test 5: Connectivity Manager
Future<void> testConnectivityManager() async {
  print('📶 Testing Connectivity Manager...');
  
  try {
    // Test initial state
    bool isConnected = ConnectivityManager.instance.isConnected;
    print('  ✓ Current connection status: ${isConnected ? 'ONLINE' : 'OFFLINE'}');
    
    // Test check connectivity
    await ConnectivityManager.instance.checkConnectivity();
    print('  ✓ Connectivity check working');
    
    // Test execute if connected
    int executionCount = 0;
    await ConnectivityManager.instance.executeIfConnected(
      () async {
        executionCount++;
        return 'Executed';
      },
      showMessage: false,
    );
    
    if (isConnected) {
      assert(executionCount == 1, 'Should execute when online');
      print('  ✓ Execute if connected working (online)');
    } else {
      assert(executionCount == 0, 'Should not execute when offline');
      print('  ✓ Execute if connected working (offline)');
    }
    
    print('  ✅ Connectivity Manager tests passed!\n');
  } catch (e) {
    print('  ❌ Connectivity Manager test failed: $e\n');
  }
}

/// Test 6: Skeleton Loader
void testSkeletonLoader() {
  print('💀 Testing Skeleton Loader...');
  
  try {
    // Test skeleton widgets creation (just verify they don't throw)
    var list = SkeletonLoader.list(itemCount: 3);
    assert(list is Widget, 'Should create list skeleton');
    
    var card = SkeletonLoader.card();
    assert(card is Widget, 'Should create card skeleton');
    
    var appointment = SkeletonLoader.appointment();
    assert(appointment is Widget, 'Should create appointment skeleton');
    
    var product = SkeletonLoader.product();
    assert(product is Widget, 'Should create product skeleton');
    
    var service = SkeletonLoader.service();
    assert(service is Widget, 'Should create service skeleton');
    
    var order = SkeletonLoader.order();
    assert(order is Widget, 'Should create order skeleton');
    
    var profile = SkeletonLoader.profile();
    assert(profile is Widget, 'Should create profile skeleton');
    
    var grid = SkeletonLoader.grid(itemCount: 6);
    assert(grid is Widget, 'Should create grid skeleton');
    
    print('  ✓ All skeleton types created successfully');
    
    // Test utility widgets
    var loadingState = LoadingStateWidget(
      isLoading: true,
      skeleton: SkeletonLoader.card(),
      child: Container(),
    );
    assert(loadingState is Widget, 'Should create loading state widget');
    
    var emptyState = EmptyStateWidget(
      title: 'Empty',
      message: 'No data',
    );
    assert(emptyState is Widget, 'Should create empty state widget');
    
    var errorState = ErrorStateWidget(
      title: 'Error',
      message: 'Failed',
    );
    assert(errorState is Widget, 'Should create error state widget');
    
    print('  ✓ Utility widgets created successfully');
    
    print('  ✅ Skeleton Loader tests passed!\n');
  } catch (e) {
    print('  ❌ Skeleton Loader test failed: $e\n');
  }
}

/// Helper: Print test section
void printSection(String title) {
  print('\n${'=' * 50}');
  print(title);
  print('=' * 50);
}
