import 'package:owner/app/backend/api/api.dart';
import 'package:owner/app/helper/shared_pref.dart';

class TabsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  TabsParser({required this.sharedPreferencesManager, required this.apiService});
}
