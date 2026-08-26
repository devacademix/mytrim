import 'package:get/get.dart';
import 'package:owner/app/helper/error_handler.dart';

class ApiChecker {
  static void checkApi(Response response) {
    ErrorHandler.handleApiError(response);
  }
}
