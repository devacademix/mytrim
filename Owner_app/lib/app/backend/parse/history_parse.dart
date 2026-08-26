import 'package:owner/app/backend/api/api.dart';
import 'package:owner/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:owner/app/util/constance.dart';

class HistoryParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  HistoryParser({required this.sharedPreferencesManager, required this.apiService});

  String getType() {
    return sharedPreferencesManager.getString('type') ?? '';
  }

  Future<Response> getSalonList({int page = 1, int limit = 20}) async {
    var response = await apiService.postPrivate(
      AppConstants.getSalonOrdersList,
      {
        "id": sharedPreferencesManager.getString('uid'),
        "page": page,
        "limit": limit,
      },
      sharedPreferencesManager.getString('token') ?? '',
    );
    return response;
  }

  Future<Response> getIndividualOrdersList({int page = 1, int limit = 20}) async {
    var response = await apiService.postPrivate(
      AppConstants.getIndividualOrdersList,
      {
        "id": sharedPreferencesManager.getString('uid'),
        "page": page,
        "limit": limit,
      },
      sharedPreferencesManager.getString('token') ?? '',
    );
    return response;
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
