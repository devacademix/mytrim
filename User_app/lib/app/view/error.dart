import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});
  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 260, width: 260, child: Image.asset("assets/images/error.png", fit: BoxFit.contain)),
                const SizedBox(height: 24),
                Text('Connection Failed'.tr, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'bold', fontSize: 20, color: ThemeProvider.textPrimary)),
                const SizedBox(height: 8),
                Text(
                  'Could not connect to network'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please check and try again'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textSecondary),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.offNamed(AppRouter.getInitialRoute()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeProvider.appColor,
                      foregroundColor: ThemeProvider.whiteColor,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text("retry".tr.toUpperCase(), style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', letterSpacing: 0.6)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
