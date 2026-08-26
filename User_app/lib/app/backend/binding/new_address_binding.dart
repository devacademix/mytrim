import 'package:get/get.dart';
import 'package:user/app/controller/new_address_controller.dart';

class NewAddressBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => NewAddressController(parser: Get.find()));
  }
}
