import 'package:get/get.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/controller/booking_controller.dart';
import 'package:user/app/controller/categories_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/near_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => TabsController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => HomeController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => CategoriesController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => NearController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => BookingController(parser: Get.find()), fenix: true);
    Get.lazyPut(() => AccountController(parser: Get.find()), fenix: true);
  }
}
