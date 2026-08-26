import 'package:get/get.dart';
import 'package:owner/app/controller/individual_profile_controller.dart';

class IndividualProfileBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => IndividualProfileController(parser: Get.find()));
  }
}
