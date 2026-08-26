import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:user/app/helper/router.dart';

/// Centralized Error Handler for User App
/// Provides consistent error handling with specific error messages and retry options
class ErrorHandler {
  /// Handle API errors with specific messages
  static void handleApiError(
    Response response, {
    Function()? onRetry,
    bool showDialog = false,
  }) {
    final ErrorType errorType = _getErrorType(response.statusCode);
    final String message = _getErrorMessage(errorType, response);

    if (errorType == ErrorType.unauthorized) {
      showToast(message);
      if (Get.isRegistered<SharedPreferencesManager>()) {
        final prefs = Get.find<SharedPreferencesManager>();
        final String? token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          prefs.clearKey('token');
          prefs.clearKey('uid');
          Get.offAllNamed(AppRouter.getInitialRoute());
        }
      }
      return;
    }

    if (showDialog) {
      _showErrorDialog(message, errorType, onRetry);
    } else {
      showToast(message);
    }
  }

  /// Get error type from status code
  static ErrorType _getErrorType(int? statusCode) {
    if (statusCode == null || statusCode == 0 || statusCode == 1) {
      return ErrorType.network;
    }

    switch (statusCode) {
      case 400:
        return ErrorType.badRequest;
      case 401:
        return ErrorType.unauthorized;
      case 403:
        return ErrorType.forbidden;
      case 404:
        return ErrorType.notFound;
      case 408:
        return ErrorType.timeout;
      case 422:
        return ErrorType.validation;
      case 429:
        return ErrorType.tooManyRequests;
      case 500:
      case 502:
      case 503:
      case 504:
        return ErrorType.server;
      default:
        return ErrorType.unknown;
    }
  }

  /// Get user-friendly error message
  static String _getErrorMessage(ErrorType errorType, Response response) {
    // Try to extract message from response
    String? extractedMessage = _extractMessageFromResponse(response);
    if (extractedMessage != null && extractedMessage.isNotEmpty) {
      return extractedMessage;
    }

    // Default messages based on error type
    switch (errorType) {
      case ErrorType.network:
        return 'Connection failed. Please check your internet connection.'.tr;
      case ErrorType.badRequest:
        return 'Invalid request. Please check your input.'.tr;
      case ErrorType.unauthorized:
        return 'Session expired. Please login again.'.tr;
      case ErrorType.forbidden:
        return 'Access denied. You don\'t have permission.'.tr;
      case ErrorType.notFound:
        return 'Resource not found.'.tr;
      case ErrorType.timeout:
        return 'Request timeout. Please try again.'.tr;
      case ErrorType.validation:
        return 'Validation error. Please check your input.'.tr;
      case ErrorType.tooManyRequests:
        return 'Too many requests. Please wait a moment.'.tr;
      case ErrorType.server:
        return 'Server error. Please try again later.'.tr;
      case ErrorType.unknown:
      default:
        return 'Something went wrong. Please try again.'.tr;
    }
  }

  /// Extract error message from API response
  static String? _extractMessageFromResponse(Response response) {
    try {
      if (response.body != null && response.body is Map) {
        final Map<String, dynamic> body = response.body;

        // Common error message keys
        final List<String> messageKeys = [
          'message',
          'error',
          'error_description',
          'errors',
          'detail',
          'msg',
        ];

        for (String key in messageKeys) {
          if (body.containsKey(key)) {
            final value = body[key];
            if (value is String && value.isNotEmpty) {
              return value;
            } else if (value is List && value.isNotEmpty) {
              return value.first.toString();
            } else if (value is Map && value.isNotEmpty) {
              return value.values.first.toString();
            }
          }
        }
      }
    } catch (e) {
      // Failed to extract message, return null
    }
    return null;
  }

  /// Show error dialog with retry option
  static void _showErrorDialog(
    String message,
    ErrorType errorType,
    Function()? onRetry,
  ) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(_getErrorIcon(errorType), color: _getErrorColor(errorType)),
            const SizedBox(width: 10),
            Text(_getErrorTitle(errorType).tr),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'.tr),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                Get.back();
                onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeProvider.appColor,
              ),
              child: Text('Retry'.tr),
            ),
          if (onRetry == null)
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeProvider.appColor,
              ),
              child: Text('OK'.tr),
            ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Get error title based on type
  static String _getErrorTitle(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.network:
        return 'Connection Error';
      case ErrorType.unauthorized:
        return 'Authentication Error';
      case ErrorType.forbidden:
        return 'Access Denied';
      case ErrorType.notFound:
        return 'Not Found';
      case ErrorType.timeout:
        return 'Timeout';
      case ErrorType.validation:
        return 'Validation Error';
      case ErrorType.server:
        return 'Server Error';
      default:
        return 'Error';
    }
  }

  /// Get icon for error type
  static IconData _getErrorIcon(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.unauthorized:
        return Icons.lock;
      case ErrorType.forbidden:
        return Icons.block;
      case ErrorType.notFound:
        return Icons.search_off;
      case ErrorType.timeout:
        return Icons.timer_off;
      case ErrorType.validation:
        return Icons.error_outline;
      case ErrorType.server:
        return Icons.cloud_off;
      default:
        return Icons.error;
    }
  }

  /// Get color for error type
  static Color _getErrorColor(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.network:
        return Colors.orange;
      case ErrorType.unauthorized:
      case ErrorType.forbidden:
        return Colors.red;
      case ErrorType.server:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /// Show loading dialog
  static void showLoadingDialog([String? message]) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  message ?? 'Please wait...'.tr,
                  style: const TextStyle(fontFamily: 'medium'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Show success message
  static void showSuccess(String message, {bool useDialog = false}) {
    if (useDialog) {
      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 10),
              Text('Success'.tr),
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
    } else {
      showToast(message);
    }
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmation({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    bool? result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title.tr),
        content: Text(message.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? ThemeProvider.appColor,
            ),
            child: Text(confirmText.tr),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show delete confirmation
  static Future<bool> showDeleteConfirmation({
    required String itemName,
  }) async {
    return await showConfirmation(
      title: 'Delete Confirmation',
      message: 'Are you sure you want to delete "$itemName"? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmColor: Colors.red,
    );
  }

  /// Handle exception (for try-catch blocks)
  static void handleException(
    dynamic exception, {
    Function()? onRetry,
    bool showDialog = false,
  }) {
    String message = 'An unexpected error occurred.'.tr;

    if (exception.toString().contains('SocketException')) {
      message = 'No internet connection.'.tr;
    } else if (exception.toString().contains('TimeoutException')) {
      message = 'Request timeout. Please try again.'.tr;
    } else if (exception.toString().contains('FormatException')) {
      message = 'Invalid data format.'.tr;
    }

    if (showDialog && onRetry != null) {
      _showErrorDialog(message, ErrorType.unknown, onRetry);
    } else {
      showToast(message);
    }
  }

  /// Validate response and handle errors
  /// Returns true if response is valid, false otherwise
  static bool validateResponse(
    Response response, {
    Function()? onRetry,
    bool showDialog = false,
  }) {
    if (response.statusCode == 200) {
      return true;
    }

    handleApiError(response, onRetry: onRetry, showDialog: showDialog);
    return false;
  }
}

/// Error types for categorization
enum ErrorType {
  network,
  unauthorized,
  forbidden,
  notFound,
  badRequest,
  timeout,
  validation,
  tooManyRequests,
  server,
  unknown,
}

/// Extension to add error handling to Response
extension ResponseErrorHandler on Response {
  /// Check if response is successful
  bool get isSuccess => statusCode == 200 || statusCode == 201;

  /// Check if response is error
  bool get isError => !isSuccess;

  /// Get error type
  ErrorType get errorType => ErrorHandler._getErrorType(statusCode);

  /// Get error message
  String get errorMessage => ErrorHandler._getErrorMessage(errorType, this);

  /// Handle error with optional retry
  void handleError({
    Function()? onRetry,
    bool showDialog = false,
  }) {
    if (isError) {
      ErrorHandler.handleApiError(this, onRetry: onRetry, showDialog: showDialog);
    }
  }
}
