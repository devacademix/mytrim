import 'package:get/get.dart';
import 'package:user/app/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => AppSearchController(parser: Get.find()));
  }
}
