import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user/app/util/theme.dart';

void showToast(String message, {bool isError = true}) {
  HapticFeedback.lightImpact();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      final context = Get.overlayContext ?? Get.context;
      if (context != null) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
            SnackBar(
              backgroundColor: isError ? Colors.red : Colors.black,
              content: Text(
                message.tr,
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          return;
        }
      }
      Get.rawSnackbar(
        message: message.tr,
        backgroundColor: isError ? Colors.red : Colors.black,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    } catch (e) {
      debugPrint("Toast Error: $e, message: $message");
    }
  });
}

void successToast(String message) {
  HapticFeedback.lightImpact();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      final context = Get.overlayContext ?? Get.context;
      if (context != null) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                message.tr,
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          return;
        }
      }
      Get.rawSnackbar(
        message: message.tr,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    } catch (e) {
      debugPrint("Success Toast Error: $e, message: $message");
    }
  });
}

void closeLoadingDialog() {
  try {
    final context = Get.overlayContext ?? Get.context;
    if (context != null) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  } catch (e) {
    debugPrint("Error closing dialog: $e");
  }
}

Future<bool> clearCartAlert() async {
  HapticFeedback.lightImpact();
  bool clean = false;
  await Get.generalDialog(
    pageBuilder: (context, __, ___) => AlertDialog(
      title: const Text('Warning'),
      content: const Text("You already have item's in cart with different grocery store"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            clean = false;
          },
          child: const Text('Cancel', style: TextStyle(color: ThemeProvider.blackColor, fontFamily: 'medium')),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            clean = true;
          },
          child: const Text('Clear Cart', style: TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')),
        )
      ],
    ),
  );
  return clean;
}
