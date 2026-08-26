import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/backend/api/handler.dart';
import 'package:owner/app/backend/models/language_model.dart';
import 'package:owner/app/backend/models/settings_model.dart';
import 'package:owner/app/backend/models/support_model.dart';
import 'package:owner/app/backend/parse/splash_parse.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashController extends GetxController implements GetxService {
  final SplashParser parser;

  late LanguageModel _defaultLanguage;
  LanguageModel get defaultLanguage => _defaultLanguage;
  late SettingsModel _settingsModel;
  SettingsModel get settinsModel => _settingsModel;

  late SupportModel _supportModel;
  SupportModel get supportModel => _supportModel;
  SplashController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    if (!kIsWeb) {
      checkNotificationPermission();
      // FirebaseMessaging.instance.getToken().then((value) {
      //   debugPrint(value.toString());
      //   parser.saveDeviceToken(value.toString());
      // });
    }
  }

  Future<void> checkNotificationPermission() async {
    try {
      if (GetPlatform.isWindows) {
        debugPrint('Firebase Messaging is not supported on Windows Desktop.');
        return;
      }
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
      firebaseMessaging.getToken().then((value) async {
        String? token = value;
        parser.saveDeviceToken(value.toString());
        debugPrint('/////////////////////////');
        debugPrint(token);
        debugPrint('/////////////////////////');
      });
    } catch (e) {
      debugPrint('Firebase messaging permission check failed: $e');
    }
  }

  Future<bool> initSharedData() {
    return parser.initAppSettings();
  }

  Future<bool> getConfigData() async {
    Response response = await parser.getAppSettings();
    bool isSuccess = false;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != null) {
        dynamic body = myMap["data"];
        if (body['settings'] != null && body['support'] != null) {
          SettingsModel appSettingsInfo = SettingsModel.fromJson(body['settings']);

          _settingsModel = appSettingsInfo;

          SupportModel supportModelInfo = SupportModel.fromJson(body['support']);
          _supportModel = supportModelInfo;
          parser.saveBasicInfo(
              appSettingsInfo.currencyCode,
              appSettingsInfo.currencySide,
              appSettingsInfo.currencySymbol,
              appSettingsInfo.smsName,
              appSettingsInfo.userVerifyWith,
              appSettingsInfo.freelancerLogin,
              appSettingsInfo.email,
              appSettingsInfo.name,
              1,
              appSettingsInfo.deliveryCharge,
              appSettingsInfo.tax,
              appSettingsInfo.logo,
              '${supportModelInfo.firstName!} ${supportModelInfo.lastName!}',
              supportModelInfo.id,
              appSettingsInfo.mobile.toString(),
              appSettingsInfo.allowDistance);
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      }
    } else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  String getLanguageCode() {
    return parser.getLanguagesCode();
  }
}
