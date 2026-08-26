import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/salon_model.dart';
import 'package:user/app/backend/models/search_individual_model.dart';
import 'package:user/app/backend/parse/search_parse.dart';
import 'package:user/app/controller/services_controller.dart';
import 'package:user/app/controller/specialist_controller.dart';
import 'package:user/app/helper/router.dart';

class AppSearchController extends GetxController implements GetxService {
  final SearchParser parser;
  TextEditingController searchController = TextEditingController();
  RxBool isEmpty = true.obs;

  List<SalonModel> _salonList = <SalonModel>[];
  List<SalonModel> get salonList => _salonList;

  List<SearchIndividualModel> _individualList = <SearchIndividualModel>[];
  List<SearchIndividualModel> get individualList => _individualList;

  String title = '';
  AppSearchController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    title = parser.getAddressName();
  }

  void onBack() {
    Get.back();
  }

  searchProducts(String name) {
    if (name.isNotEmpty && name != '') {
      getSearchResult(name);
    } else {
      _salonList = [];
      _individualList = [];
      isEmpty = true.obs;
      update();
    }
  }

  void getSearchResult(String query) async {
    var param = {"param": query, "lat": parser.getLat(), "lng": parser.getLng()};
    Response response = await parser.getSearchResult(param);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var salonData = myMap['salon'];
      var individualData = myMap['individual'];
      _salonList = [];
      _individualList = [];

      salonData.forEach((data) {
        SalonModel salon = SalonModel.fromJson(data);
        _salonList.add(salon);
      });

      individualData.forEach((data) {
        SearchIndividualModel individual = SearchIndividualModel.fromJson(data);
        _individualList.add(individual);
      });
      isEmpty = false.obs;
      debugPrint(salonList.length.toString());
      debugPrint(individualList.length.toString());
    } else {
      isEmpty = false.obs;
      ApiChecker.checkApi(response);
    }
    update();
  }

  void clearData() {
    searchController.clear();
    _salonList = [];
    _individualList = [];
    isEmpty = true.obs;
    update();
  }

  void onServices(int uid) {
    Get.delete<ServicesController>(force: true);
    Get.toNamed(AppRouter.getServicesRoutes(), arguments: [uid]);
  }

  void onSpecialist(int uid) {
    Get.delete<SpecialistController>(force: true);
    Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [uid]);
  }
}
