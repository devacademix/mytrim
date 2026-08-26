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

  // Pagination variables
  int _currentPage = 1;
  int _oldPage = 1;
  final int _pageSize = 20;
  bool _hasMoreData = true;
  bool _hasMoreOldData = true;
  bool _isLoadingMore = false;
  bool _isLoadingMoreOld = false;

  bool get hasMoreData => _hasMoreData;
  bool get hasMoreOldData => _hasMoreOldData;
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoadingMoreOld => _isLoadingMoreOld;

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    tabController = TabController(length: 2, vsync: this);
    getList();
  }

  Future<void> getList() async {
    if (parser.getType() == 'salon') {
      await getSalonAppointmentById();
    } else {
      await getIndividualAppointmentsById();
    }
  }

  Future<void> getSalonAppointmentById({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasMoreData) return;
      _isLoadingMore = true;
      _currentPage++;
    } else {
      _currentPage = 1;
      _hasMoreData = true;
      _appointmentList = [];
    }
    
    update();

    Response response = await parser.getSalonList(page: _currentPage, limit: _pageSize);
    apiCalled = true;
    
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      
      if (body == null || (body is List && body.isEmpty)) {
        _hasMoreData = false;
      } else {
        List<AppointmentModel> newAppointments = [];
        body.forEach((data) {
          AppointmentModel appointment = AppointmentModel.fromJson(data);
          if (appointment.status == 0) {
            newAppointments.add(appointment);
          }
        });
        
        if (loadMore) {
          _appointmentList.addAll(newAppointments);
        } else {
          _appointmentList = newAppointments;
        }
        
        // Check if we got fewer items than requested
        if (newAppointments.length < _pageSize) {
          _hasMoreData = false;
        }
      }
    } else {
      ApiChecker.checkApi(response);
      if (loadMore) {
        _currentPage--; // Revert page increment on error
      }
    }
    
    _isLoadingMore = false;
    update();
  }

  Future<void> getSalonOldAppointments({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMoreOld || !_hasMoreOldData) return;
      _isLoadingMoreOld = true;
      _oldPage++;
    } else {
      _oldPage = 1;
      _hasMoreOldData = true;
      _appointmentListOld = [];
    }
    
    update();

    Response response = await parser.getSalonList(page: _oldPage, limit: _pageSize);
    apiCalled = true;
    
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      
      if (body == null || (body is List && body.isEmpty)) {
        _hasMoreOldData = false;
      } else {
        List<AppointmentModel> newAppointments = [];
        body.forEach((data) {
          AppointmentModel appointment = AppointmentModel.fromJson(data);
          if (appointment.status != 0) {
            newAppointments.add(appointment);
          }
        });
        
        if (loadMore) {
          _appointmentListOld.addAll(newAppointments);
        } else {
          _appointmentListOld = newAppointments;
        }
        
        if (newAppointments.length < _pageSize) {
          _hasMoreOldData = false;
        }
      }
    } else {
      ApiChecker.checkApi(response);
      if (loadMore) {
        _oldPage--;
      }
    }
    
    _isLoadingMoreOld = false;
    update();
  }

  Future<void> getIndividualAppointmentsById({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasMoreData) return;
      _isLoadingMore = true;
      _currentPage++;
    } else {
      _currentPage = 1;
      _hasMoreData = true;
      _appointmentList = [];
    }
    
    update();

    Response response = await parser.getIndividualAppointmentsList(page: _currentPage, limit: _pageSize);
    apiCalled = true;
    
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      
      if (body == null || (body is List && body.isEmpty)) {
        _hasMoreData = false;
      } else {
        List<AppointmentModel> newAppointments = [];
        body.forEach((data) {
          AppointmentModel appointment = AppointmentModel.fromJson(data);
          if (appointment.status == 0) {
            newAppointments.add(appointment);
          }
        });
        
        if (loadMore) {
          _appointmentList.addAll(newAppointments);
        } else {
          _appointmentList = newAppointments;
        }
        
        if (newAppointments.length < _pageSize) {
          _hasMoreData = false;
        }
      }
    } else {
      ApiChecker.checkApi(response);
      if (loadMore) {
        _currentPage--;
      }
    }
    
    _isLoadingMore = false;
    update();
  }

  Future<void> getIndividualOldAppointments({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMoreOld || !_hasMoreOldData) return;
      _isLoadingMoreOld = true;
      _oldPage++;
    } else {
      _oldPage = 1;
      _hasMoreOldData = true;
      _appointmentListOld = [];
    }
    
    update();

    Response response = await parser.getIndividualAppointmentsList(page: _oldPage, limit: _pageSize);
    apiCalled = true;
    
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      
      if (body == null || (body is List && body.isEmpty)) {
        _hasMoreOldData = false;
      } else {
        List<AppointmentModel> newAppointments = [];
        body.forEach((data) {
          AppointmentModel appointment = AppointmentModel.fromJson(data);
          if (appointment.status != 0) {
            newAppointments.add(appointment);
          }
        });
        
        if (loadMore) {
          _appointmentListOld.addAll(newAppointments);
        } else {
          _appointmentListOld = newAppointments;
        }
        
        if (newAppointments.length < _pageSize) {
          _hasMoreOldData = false;
        }
      }
    } else {
      ApiChecker.checkApi(response);
      if (loadMore) {
        _oldPage--;
      }
    }
    
    _isLoadingMoreOld = false;
    update();
  }

  /// Load more new appointments
  void loadMoreAppointments() {
    if (parser.getType() == 'salon') {
      getSalonAppointmentById(loadMore: true);
    } else {
      getIndividualAppointmentsById(loadMore: true);
    }
  }

  /// Load more old appointments
  void loadMoreOldAppointments() {
    if (parser.getType() == 'salon') {
      getSalonOldAppointments(loadMore: true);
    } else {
      getIndividualOldAppointments(loadMore: true);
    }
  }

  /// Refresh appointments (pull to refresh)
  Future<void> refreshAppointments() async {
    await getList();
  }

  void onAppointment(int id) {
    Get.delete<OrderDetailsController>(force: true);
    Get.toNamed(AppRouter.getOrderDetailsRoute(), arguments: [id]);
  }
}
