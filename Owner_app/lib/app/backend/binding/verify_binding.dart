import 'package:get/get.dart';
import 'package:owner/app/controller/verify_controller.dart';

class VerifyBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => VerifyController(parser: Get.find()));
  }
}
