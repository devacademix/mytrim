import 'package:get/get.dart';
import 'package:user/app/controller/intro_controller.dart';

class IntroBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => IntroController(parser: Get.find()));
  }
}
