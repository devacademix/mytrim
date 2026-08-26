import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/splash_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/helper/router.dart';
import 'package:owner/app/util/theme.dart';
import 'package:owner/app/util/toast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initConnectivity();
    Get.find<SplashController>().initSharedData();
    _routing();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _routing() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        if (Get.find<SplashController>().getLanguageCode() != '') {
          var locale = Get.find<SplashController>().getLanguageCode();
          Get.updateLocale(Locale(locale));
        } else {
          var locale = Get.find<SplashController>().defaultLanguage.languageCode != '' && Get.find<SplashController>().defaultLanguage.languageCode != ''
              ? Locale(Get.find<SplashController>().defaultLanguage.languageCode.toString())
              : Locale('en'.tr);
          Get.updateLocale(locale);
        }

        if (Get.find<SplashController>().parser.haveLoggedIn() == true) {
          Get.offNamed(AppRouter.getTabRoute());
        } else {
          Get.offNamed(AppRouter.getInitialRoute());
        }
      } else {
        Get.toNamed(AppRouter.getErrorRoutes());
      }
    });
  }

  Future<void> initConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi));
    if (!hasInternet) {
      showToast('No Internet Connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.appColor,
          body: Stack(alignment: AlignmentDirectional.center, children: [
            const Image(image: AssetImage('assets/images/splash.png'), fit: BoxFit.cover, height: double.infinity, width: double.infinity, alignment: Alignment.center),
            Positioned(
              top: 96,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: ThemeProvider.whiteColor.withOpacity(0.12), shape: BoxShape.circle),
                child: const Image(image: AssetImage('assets/images/logo_white.png'), fit: BoxFit.cover, height: 50, width: 50, alignment: Alignment.center),
              ),
            ),
const Positioned(
              top: 180,
              child: Center(
                child: Text(Environments.appName, style: TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 18, letterSpacing: 0.3)),
              ),
            ),
            const Positioned(bottom: 56, child: Center(child: SizedBox(height: 26, width: 26, child: CircularProgressIndicator(color: ThemeProvider.whiteColor, strokeWidth: 2.6)))),
            Positioned(
              bottom: 22,
              child: Center(
                child: Text(
                  'Developed By '.tr + Environments.companyName,
                  style: TextStyle(color: ThemeProvider.whiteColor.withOpacity(0.85), fontFamily: 'bold', fontSize: 12),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}
