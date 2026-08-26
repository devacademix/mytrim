import 'package:get/get.dart';
import 'package:owner/app/controller/shop_subcategories_controller.dart';

class ShopSubCategoriesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => ShopSubCategoriesController(parser: Get.find()));
  }
}
