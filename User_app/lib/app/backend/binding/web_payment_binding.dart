import 'package:get/get.dart';
import 'package:user/app/controller/web_payment_controller.dart';

class WebPaymentBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => WebPaymentController(parser: Get.find()));
  }
}
