import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/splash_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';

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

        if (Get.find<SplashController>().parser.isNewUser() == false) {
          Get.find<SplashController>().parser.saveWelcome(true);
          Get.offNamed(AppRouter.getInitialRoute());
        } else {
          Get.find<SplashController>().parser.saveWelcome(true);
          Get.offNamed(AppRouter.getChooseLocationRoutes());
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
              top: 110,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.whiteColor.withOpacity(0.12)),
                    child: const Image(image: AssetImage('assets/images/logo_white.png'), fit: BoxFit.cover, height: 50, width: 50, alignment: Alignment.center),
                  ),
                  const SizedBox(height: 16),
                  const Text(Environments.appName, style: TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 18, letterSpacing: 0.2)),
                ],
              ),
            ),
            const Positioned(bottom: 56, child: Center(child: CircularProgressIndicator(color: ThemeProvider.whiteColor, strokeWidth: 2.4))),
            Positioned(bottom: 20, child: Center(child: Text('Developed By '.tr + Environments.companyName, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'regular', fontSize: 12)))),
          ]),
        );
      },
    );
  }
}
