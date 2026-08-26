import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:owner/app/backend/api/handler.dart';
import 'package:owner/app/backend/models/services_model.dart';
import 'package:owner/app/backend/parse/services_parse.dart';
import 'package:owner/app/controller/add_services_controller.dart';
import 'package:owner/app/helper/router.dart';
import 'package:owner/app/util/constance.dart';
import 'package:owner/app/util/toast.dart';

class ServicesController extends GetxController implements GetxService {
  final ServicesParser parser;

  String title = 'Services';
  List<ServicesModel> _servicesList = <ServicesModel>[];
  List<ServicesModel> get servicesList => _servicesList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  bool apiCalled = false;

  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;

  ServicesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getServices();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
  }

  Future<void> getServices({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasMoreData) return;
      _isLoadingMore = true;
      _currentPage++;
    } else {
      _currentPage = 1;
      _hasMoreData = true;
    }

    try {
      var response = await parser.getServices(
        {"id": parser.sharedPreferencesManager.getString('uid')},
        page: _currentPage,
        limit: _pageSize,
      );
      debugPrint('getServices uid: ${parser.sharedPreferencesManager.getString('uid')}');
      debugPrint('getServices status: ${response.statusCode}, body: ${response.bodyString}');
      apiCalled = true;

      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        var body = myMap['data'];

        if (body == null || (body is List && body.isEmpty)) {
          if (!loadMore) {
            _servicesList = [];
          }
          _hasMoreData = false;
        } else {
          List<ServicesModel> newServices = [];
          if (body is List) {
            body.forEach((element) {
              if (element != null) {
                ServicesModel service = ServicesModel.fromJson(element);
                newServices.add(service);
              }
            });
          }

          if (loadMore) {
            _servicesList.addAll(newServices);
          } else {
            _servicesList = newServices;
          }

          if (newServices.length < _pageSize) {
            _hasMoreData = false;
          }
        }
      } else {
        ApiChecker.checkApi(response);
        if (loadMore) {
          _currentPage--;
        }
      }
    } catch (e) {
      debugPrint('Error getting services: $e');
      apiCalled = true;
    } finally {
      _isLoadingMore = false;
      update();
    }
  }

  void loadMoreServices() {
    getServices(loadMore: true);
  }

  Future<void> refreshServices() async {
    await getServices();
  }

  Future<void> updateStatus(int id, int status) async {
    var body = {"status": status == 1 ? 0 : 1, "id": id};
    var response = await parser.onUpdateServices(body);
    if (response.statusCode == 200) {
      debugPrint(response.bodyString);
      successToast('Updated');
      getServices();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void onAddNew() {
    Get.delete<AddServicesController>(force: true);
    Get.toNamed(AppRouter.getAddServicesRoute(), arguments: ['new']);
  }

  void onEdit(int id) {
    Get.delete<AddServicesController>(force: true);
    Get.toNamed(AppRouter.getAddServicesRoute(), arguments: ['edit', id]);
  }

  void onDestroy(int id) async {
    var param = {"id": id};
    debugPrint('id ---> $id');
    var response = await parser.servicesDestroy(param);
    if (response.statusCode == 200) {
      getServices();
      showToast('item remove successfully');
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
