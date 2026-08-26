import 'package:user/app/config/app_config.dart';

class Environments {
  static const String appName = 'MyTrim';
  static const String companyName = 'MyTrim';
  static String get googleMapsKey => AppConfig.googleMapsKey;
  static String get apiBaseURL => AppConfig.baseUrl;
  static const String websiteURL = 'http://10.0.2.2:4201/';
}
