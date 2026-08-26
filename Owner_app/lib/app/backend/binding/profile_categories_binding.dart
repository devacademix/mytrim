import 'package:get/get.dart';
import 'package:owner/app/controller/profile_categories_controller.dart';

class ProfileCategoriesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => ProfileCategoriesController(parser: Get.find()));
  }
}
