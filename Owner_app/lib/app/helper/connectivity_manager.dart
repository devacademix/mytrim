import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/util/theme.dart';

/// Connectivity Manager
/// Monitors internet connectivity and provides offline detection
/// 
/// Usage:
/// ```dart
/// // Check current connection
/// bool isOnline = await ConnectivityManager.instance.isConnected;
/// 
/// // Listen to connectivity changes
/// ConnectivityManager.instance.connectionStatus.listen((isConnected) {
///   if (isConnected) {
///     print('Online');
///   } else {
///     print('Offline');
///   }
/// });
/// 
/// // Show offline banner
/// ConnectivityManager.instance.showOfflineBanner();
/// 
/// // Hide offline banner
/// ConnectivityManager.instance.hideOfflineBanner();
/// ```
class ConnectivityManager {
  static ConnectivityManager? _instance;
  final Connectivity _connectivity = Connectivity();
  
  StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  bool _isConnected = true;
  bool _bannerVisible = false;
  OverlayEntry? _overlayEntry;
  
  // Private constructor
  ConnectivityManager._();
  
  // Singleton instance
  static ConnectivityManager get instance {
    _instance ??= ConnectivityManager._();
    return _instance!;
  }

  /// Stream of connection status changes
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  /// Current connection status
  bool get isConnected => _isConnected;

  /// Check if banner is visible
  bool get isBannerVisible => _bannerVisible;

  /// Initialize connectivity monitoring
  Future<void> init() async {
    // Check initial connectivity
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  /// Update connection status
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool wasConnected = _isConnected;
    
    // Check if any result indicates connectivity
    _isConnected = results.any((result) => 
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet ||
      result == ConnectivityResult.vpn
    );

    // Notify listeners if status changed
    if (wasConnected != _isConnected) {
      _connectionStatusController.add(_isConnected);
      
      if (_isConnected) {
        debugPrint('📶 Connection: ONLINE');
        hideOfflineBanner();
      } else {
        debugPrint('📵 Connection: OFFLINE');
        showOfflineBanner();
      }
    }
  }

  /// Check current connectivity
  Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
    return _isConnected;
  }

  /// Show offline banner
  void showOfflineBanner() {
    if (_bannerVisible || Get.overlayContext == null) return;

    _bannerVisible = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.red.shade700,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'No internet connection'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'medium',
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(Get.overlayContext!)?.insert(_overlayEntry!);
  }

  /// Hide offline banner
  void hideOfflineBanner() {
    if (!_bannerVisible) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    _bannerVisible = false;
  }

  /// Show offline snackbar
  void showOfflineSnackbar() {
    Get.snackbar(
      'No Connection'.tr,
      'Please check your internet connection'.tr,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      icon: const Icon(Icons.wifi_off, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show connection restored snackbar
  void showConnectionRestoredSnackbar() {
    Get.snackbar(
      'Connected'.tr,
      'Internet connection restored'.tr,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      icon: const Icon(Icons.wifi, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  /// Execute function only if connected
  Future<T?> executeIfConnected<T>(
    Future<T> Function() function, {
    bool showMessage = true,
  }) async {
    if (!_isConnected) {
      if (showMessage) {
        showOfflineSnackbar();
      }
      return null;
    }
    return await function();
  }

  /// Dispose
  void dispose() {
    _connectionStatusController.close();
    hideOfflineBanner();
  }
}

/// Connectivity Widget
/// Wraps a widget to show different UI based on connectivity
class ConnectivityWidget extends StatelessWidget {
  final Widget child;
  final Widget? offlineChild;
  final bool showBanner;

  const ConnectivityWidget({
    Key? key,
    required this.child,
    this.offlineChild,
    this.showBanner = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityManager.instance.connectionStatus,
      initialData: ConnectivityManager.instance.isConnected,
      builder: (context, snapshot) {
        final bool isConnected = snapshot.data ?? true;

        if (!isConnected && offlineChild != null) {
          return offlineChild!;
        }

        return child;
      },
    );
  }
}

/// Offline Indicator Widget
/// Shows a persistent offline indicator at the top or bottom
class OfflineIndicator extends StatelessWidget {
  final bool showAtTop;
  final Color? backgroundColor;
  final String? message;

  const OfflineIndicator({
    Key? key,
    this.showAtTop = true,
    this.backgroundColor,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityManager.instance.connectionStatus,
      initialData: ConnectivityManager.instance.isConnected,
      builder: (context, snapshot) {
        final bool isConnected = snapshot.data ?? true;

        if (isConnected) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          color: backgroundColor ?? Colors.red.shade700,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message ?? 'No internet connection'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'medium',
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Connectivity Button
/// Button that shows different states based on connectivity
class ConnectivityButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String? offlineText;
  final bool enabled;
  final Widget? child;

  const ConnectivityButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.offlineText,
    this.enabled = true,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityManager.instance.connectionStatus,
      initialData: ConnectivityManager.instance.isConnected,
      builder: (context, snapshot) {
        final bool isConnected = snapshot.data ?? true;
        final bool isEnabled = enabled && isConnected;

        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? ThemeProvider.appColor : Colors.grey,
          ),
          child: child ??
              Text(
                isConnected ? text : (offlineText ?? 'Offline'.tr),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'medium',
                ),
              ),
        );
      },
    );
  }
}

/// Extension to add connectivity checks to GetxController
extension ConnectivityControllerExtension on GetxController {
  /// Execute function only if connected
  Future<T?> executeIfConnected<T>(
    Future<T> Function() function, {
    bool showMessage = true,
  }) async {
    return await ConnectivityManager.instance.executeIfConnected(
      function,
      showMessage: showMessage,
    );
  }

  /// Check if device is connected
  bool get isConnected => ConnectivityManager.instance.isConnected;
}

/// Reactive connectivity controller
class ConnectivityController extends GetxController {
  final _isConnected = true.obs;
  StreamSubscription<bool>? _subscription;

  bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    _isConnected.value = ConnectivityManager.instance.isConnected;
    _subscription = ConnectivityManager.instance.connectionStatus.listen((status) {
      _isConnected.value = status;
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
