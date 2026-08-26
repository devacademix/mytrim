import 'package:get/get.dart';
import 'package:owner/app/controller/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => SignUpController(parser: Get.find()));
  }
}
