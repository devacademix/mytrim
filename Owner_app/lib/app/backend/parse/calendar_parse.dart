import 'package:owner/app/backend/api/api.dart';
import 'package:owner/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:owner/app/util/constance.dart';

class CalendarsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CalendarsParser({required this.sharedPreferencesManager, required this.apiService});

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  String getType() {
    return sharedPreferencesManager.getString('type') ?? '';
  }

  Future<Response> getCalendarView() async {
    return await apiService.postPrivate(AppConstants.calendarView, {'id': getUID(), "type": getType()}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getByDate(var body) async {
    return await apiService.postPrivate(AppConstants.getByDate, body, sharedPreferencesManager.getString('token') ?? '');
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ?? AppConstants.defaultCurrencyCode;
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ?? AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ?? AppConstants.defaultCurrencySymbol;
  }
}
