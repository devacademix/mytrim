import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/util/theme.dart';

/// Centralized Loading Manager
/// Replaces scattered Get.dialog() loading dialogs with a consistent, managed approach
/// Tracks loading state and prevents multiple dialogs
/// 
/// Usage:
/// ```dart
/// // Show loading
/// LoadingManager.show('Loading data...');
/// 
/// // Hide loading
/// LoadingManager.hide();
/// 
/// // Execute with loading
/// await LoadingManager.execute(
///   () => apiService.getData(),
///   message: 'Loading...',
/// );
/// 
/// // Execute with loading and error handling
/// await LoadingManager.executeWithErrorHandling(
///   () => apiService.getData(),
///   message: 'Loading...',
///   onError: (error) => print('Error: $error'),
/// );
/// ```
class LoadingManager {
  static bool _isLoading = false;
  static String? _currentMessage;
  static DateTime? _loadingStartTime;

  /// Check if loading is currently shown
  static bool get isLoading => _isLoading;

  /// Get current loading message
  static String? get currentMessage => _currentMessage;

  /// Show loading dialog
  /// 
  /// [message] - Loading message to display
  /// [dismissible] - Whether dialog can be dismissed by tapping outside (default: false)
  static void show([String? message, bool dismissible = false]) {
    if (_isLoading) {
      // Already showing, just update message if different
      if (message != null && message != _currentMessage) {
        hide();
        _showDialog(message, dismissible);
      }
      return;
    }

    _showDialog(message ?? 'Please wait...'.tr, dismissible);
  }

  /// Internal method to show dialog
  static void _showDialog(String message, bool dismissible) {
    _isLoading = true;
    _currentMessage = message;
    _loadingStartTime = DateTime.now();

    Get.dialog(
      WillPopScope(
        onWillPop: () async => dismissible,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: ThemeProvider.appColor,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'medium',
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: dismissible,
      barrierColor: Colors.black45,
    );
  }

  /// Hide loading dialog
  static void hide() {
    if (!_isLoading) return;

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    _isLoading = false;
    _currentMessage = null;

    // Log loading duration in debug mode
    if (_loadingStartTime != null) {
      final duration = DateTime.now().difference(_loadingStartTime!);
      if (duration.inSeconds > 5) {
        debugPrint('⚠️ Long loading duration: ${duration.inSeconds}s');
      }
      _loadingStartTime = null;
    }
  }

  /// Force hide - even if dialog state is inconsistent
  static void forceHide() {
    _isLoading = false;
    _currentMessage = null;
    _loadingStartTime = null;

    // Try to close dialog multiple times if needed
    int attempts = 0;
    while ((Get.isDialogOpen ?? false) && attempts < 3) {
      Get.back();
      attempts++;
    }
  }

  /// Show loading with minimum duration
  /// Ensures loading is shown for at least [minDuration] milliseconds
  /// Useful for preventing flashing loaders on fast operations
  static Future<void> showWithMinDuration(
    Future<void> Function() function, {
    String? message,
    int minDuration = 500,
  }) async {
    show(message);
    final startTime = DateTime.now();

    try {
      await function();
    } finally {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      if (elapsed < minDuration) {
        await Future.delayed(Duration(milliseconds: minDuration - elapsed));
      }
      hide();
    }
  }

  /// Execute function with loading dialog
  /// 
  /// [function] - Async function to execute
  /// [message] - Loading message
  /// [dismissible] - Whether dialog can be dismissed
  /// Returns the result of the function
  static Future<T> execute<T>(
    Future<T> Function() function, {
    String? message,
    bool dismissible = false,
  }) async {
    show(message, dismissible);
    try {
      final result = await function();
      return result;
    } finally {
      hide();
    }
  }

  /// Execute function with loading and error handling
  /// 
  /// [function] - Async function to execute
  /// [message] - Loading message
  /// [onSuccess] - Callback on success
  /// [onError] - Callback on error
  /// [showErrorDialog] - Show error in dialog (default: false, shows toast)
  /// Returns the result or null on error
  static Future<T?> executeWithErrorHandling<T>(
    Future<T> Function() function, {
    String? message,
    void Function(T result)? onSuccess,
    void Function(dynamic error)? onError,
    bool showErrorDialog = false,
  }) async {
    show(message);
    try {
      final result = await function();
      hide();
      onSuccess?.call(result);
      return result;
    } catch (error) {
      hide();
      
      if (onError != null) {
        onError(error);
      } else {
        // Default error handling
        final errorMessage = _extractErrorMessage(error);
        if (showErrorDialog) {
          _showErrorDialog(errorMessage);
        } else {
          Get.snackbar(
            'Error'.tr,
            errorMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      }
      return null;
    }
  }

  /// Execute function with loading and success message
  static Future<T?> executeWithSuccess<T>(
    Future<T> Function() function, {
    String? loadingMessage,
    required String successMessage,
    void Function(T result)? onSuccess,
  }) async {
    show(loadingMessage);
    try {
      final result = await function();
      hide();
      
      Get.snackbar(
        'Success'.tr,
        successMessage.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      onSuccess?.call(result);
      return result;
    } catch (error) {
      hide();
      final errorMessage = _extractErrorMessage(error);
      Get.snackbar(
        'Error'.tr,
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return null;
    }
  }

  /// Extract error message from various error types
  static String _extractErrorMessage(dynamic error) {
    if (error is String) return error;
    if (error is Exception) return error.toString();
    if (error.toString().contains('SocketException')) {
      return 'No internet connection'.tr;
    }
    if (error.toString().contains('TimeoutException')) {
      return 'Request timeout'.tr;
    }
    return 'Something went wrong'.tr;
  }

  /// Show error dialog
  static void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 10),
            Text('Error'.tr),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeProvider.appColor,
            ),
            child: Text('OK'.tr),
          ),
        ],
      ),
    );
  }

  /// Show loading overlay on entire screen
  /// Used for operations that should block all interaction
  static void showOverlay({String? message}) {
    if (_isLoading) return;

    _isLoading = true;
    _currentMessage = message;
    _loadingStartTime = DateTime.now();

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: ThemeProvider.appColor,
                      strokeWidth: 4,
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      message,
                      style: const TextStyle(
                        fontFamily: 'bold',
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Show linear progress indicator at top of screen
  /// Non-blocking, allows user interaction
  static OverlayEntry? _progressOverlay;

  static void showProgress({String? message}) {
    if (_progressOverlay != null) return;

    _progressOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: ThemeProvider.appColor.withOpacity(0.9),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SafeArea(
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      message ?? 'Loading...'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'medium',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(Get.overlayContext!)?.insert(_progressOverlay!);
  }

  /// Hide progress indicator
  static void hideProgress() {
    _progressOverlay?.remove();
    _progressOverlay = null;
  }
}

/// Loading state tracker for reactive UI
class LoadingState extends GetxController {
  final _isLoading = false.obs;
  final _message = ''.obs;

  bool get isLoading => _isLoading.value;
  String get message => _message.value;

  void show([String? message]) {
    _isLoading.value = true;
    _message.value = message ?? 'Loading...'.tr;
  }

  void hide() {
    _isLoading.value = false;
    _message.value = '';
  }
}

/// Extension for easy loading state management in controllers
extension LoadingControllerExtension on GetxController {
  /// Execute with loading state
  Future<T> withLoading<T>(
    Future<T> Function() function, {
    String? message,
  }) async {
    return await LoadingManager.execute(function, message: message);
  }

  /// Execute with loading and error handling
  Future<T?> withLoadingAndErrorHandling<T>(
    Future<T> Function() function, {
    String? message,
    void Function(T result)? onSuccess,
    void Function(dynamic error)? onError,
  }) async {
    return await LoadingManager.executeWithErrorHandling(
      function,
      message: message,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
