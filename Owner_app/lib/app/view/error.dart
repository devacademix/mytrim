import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/helper/router.dart';
import 'package:owner/app/util/theme.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});
  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.surfaceTint,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 220, width: 220, child: Image.asset("assets/images/error.png", fit: BoxFit.contain)),
                const SizedBox(height: 24),
                Text('Connection Failed'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                const SizedBox(height: 8),
                Text('Could not connect to network'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: ThemeProvider.mutedTextColor)),
                const SizedBox(height: 2),
                Text('Please check and try again'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: ThemeProvider.mutedTextColor)),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.offNamed(AppRouter.getInitialRoute()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeProvider.appColor,
                      foregroundColor: ThemeProvider.whiteColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text("retry".tr.toUpperCase(), style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 15, letterSpacing: 0.5)),
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
