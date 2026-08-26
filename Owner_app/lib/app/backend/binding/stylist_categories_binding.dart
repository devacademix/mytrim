import 'package:get/get.dart';
import 'package:owner/app/controller/stylist_categories_controller.dart';

class StylistCategoriesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => StylistCategoriesController(parser: Get.find()));
  }
}
