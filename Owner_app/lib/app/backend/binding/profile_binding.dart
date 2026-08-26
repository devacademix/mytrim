import 'package:get/get.dart';
import 'package:owner/app/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => ProfileController(parser: Get.find()));
  }
}
