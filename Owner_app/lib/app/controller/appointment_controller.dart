import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/backend/api/handler.dart';
import 'package:owner/app/backend/models/appointment_model.dart';
import 'package:owner/app/backend/parse/appointment_parse.dart';
import 'package:owner/app/controller/order_details_controller.dart';
import 'package:owner/app/helper/router.dart';
import 'package:owner/app/util/constance.dart';

class AppointmentController extends GetxController with GetTickerProviderStateMixin implements GetxService {
  final AppointmentParser parser;

  List<AppointmentModel> _appointmentList = <AppointmentModel>[];
  List<AppointmentModel> get appointmentList => _appointmentList;

  List<AppointmentModel> _appointmentListOld = <AppointmentModel>[];
  List<AppointmentModel> get appointmentListOld => _appointmentListOld;

  bool apiCalled = false;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<String> statusName = ['Created'.tr, 'Accepted'.tr, 'Rejected'.tr, 'Ongoing'.tr, 'Completed'.tr, 'Cancelled'.tr, 'Refunded'.tr, 'Delayed'.tr, 'Panding Payment'.tr];
  AppointmentController({required this.parser});

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    tabController = TabController(length: 2, vsync: this);
    getList();
  }

  void getList() {
    if (parser.getType() == 'salon') {
      getSalonAppointmentById();
    } else {
      getIndividualAppointmentsById();
    }
  }

  Future<void> getSalonAppointmentById() async {
    Response response = await parser.getSalonList();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      _appointmentList = [];
      _appointmentListOld = [];
      body.forEach((data) {
        AppointmentModel appointment = AppointmentModel.fromJson(data);
        if (appointment.status == 0) {
          _appointmentList.add(appointment);
        } else {
          _appointmentListOld.add(appointment);
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getIndividualAppointmentsById() async {
    Response response = await parser.getIndividualAppointmentsList();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      _appointmentList = [];
      _appointmentListOld = [];
      body.forEach((data) {
        AppointmentModel appointment = AppointmentModel.fromJson(data);
        if (appointment.status == 0) {
          _appointmentList.add(appointment);
        } else {
          _appointmentListOld.add(appointment);
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onAppointment(int id) {
    Get.delete<OrderDetailsController>(force: true);
    Get.toNamed(AppRouter.getOrderDetailsRoute(), arguments: [id]);
  }
}
