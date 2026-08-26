import 'package:owner/app/backend/api/api.dart';
import 'package:owner/app/helper/shared_pref.dart';

class AddTimingParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddTimingParser({required this.sharedPreferencesManager, required this.apiService});

  bool getType() {
    return sharedPreferencesManager.getString('type') == 'salon' ? true : false;
  }
}
