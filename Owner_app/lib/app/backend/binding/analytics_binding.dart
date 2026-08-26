import 'package:get/get.dart';
import 'package:owner/app/controller/analytics_controller.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => AnalyticsController(parser: Get.find()));
  }
}
