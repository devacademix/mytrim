import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/backend/api/handler.dart';
import 'package:owner/app/backend/models/products_order_model.dart';
import 'package:owner/app/backend/parse/history_parse.dart';
import 'package:owner/app/controller/product_order_details_controller.dart';
import 'package:owner/app/helper/router.dart';
import 'package:owner/app/util/constance.dart';

class HistoryController extends GetxController with GetTickerProviderStateMixin implements GetxService {
  final HistoryParser parser;

  late TabController tabController;

  List<ProductSalonModel> _productSalonList = <ProductSalonModel>[];
  List<ProductSalonModel> get productSalonList => _productSalonList;

  List<ProductSalonModel> _productSalonListOld = <ProductSalonModel>[];
  List<ProductSalonModel> get productSalonListOld => _productSalonListOld;

  bool apiCalled = false;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<String> statusName = ['Created'.tr, 'Accepted'.tr, 'Rejected'.tr, 'Ongoing'.tr, 'Completed'.tr, 'Cancelled'.tr, 'Refunded'.tr, 'Delayed'.tr, 'Panding Payment'.tr];
  
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

  HistoryController({required this.parser});

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
      await getSalonList();
    } else {
      await getIndividualOrdersList();
    }
  }

  Future<void> getIndividualOrdersList({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasMoreData) return;
      _isLoadingMore = true;
      _currentPage++;
    } else {
      _currentPage = 1;
      _hasMoreData = true;
      _productSalonList = [];
    }

    update();

    Response response = await parser.getIndividualOrdersList(page: _currentPage, limit: _pageSize);
    apiCalled = true;
    
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      
      if (body == null || (body is List && body.isEmpty)) {
        _hasMoreData = false;
      } else {
        List<ProductSalonModel> newOrders = [];
        body.forEach((data) {
          ProductSalonModel productSalon = ProductSalonModel.fromJson(data);
          if (productSalon.status == 0) {
            newOrders.add(productSalon);
          }
        });
        
        if (loadMore) {
          _productSalonList.addAll(newOrders);
        } else {
          _productSalonList = newOrders;
        }
        
        if (newOrders.length < _pageSize) {
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

  Future<void> getIndividualOldOrdersList({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMoreOld || !_hasMoreOldData) return;
      _isLoadingMoreOld = true;
      _oldPage++;
    } else {
      _oldPage = 1;
      _hasMoreOldData = true;
      _productSalonListOld = [];
    }

    update();

    Response response = await parser.getIndividualOrdersList(page: _oldPage, limit: _pageSize);
    apiCalled = true;
    
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      
      if (body == null || (body is List && body.isEmpty)) {
        _hasMoreOldData = false;
      } else {
        List<ProductSalonModel> newOrders = [];
        body.forEach((data) {
          ProductSalonModel productSalon = ProductSalonModel.fromJson(data);
          if (productSalon.status != 0) {
            newOrders.add(productSalon);
          }
        });
        
        if (loadMore) {
          _productSalonListOld.addAll(newOrders);
        } else {
          _productSalonListOld = newOrders;
        }
        
        if (newOrders.length < _pageSize) {
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

  Future<void> getSalonList({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasMoreData) return;
      _isLoadingMore = true;
      _currentPage++;
    } else {
      _currentPage = 1;
      _hasMoreData = true;
      _productSalonList = [];
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
        List<ProductSalonModel> newOrders = [];
        body.forEach((data) {
          ProductSalonModel productSalon = ProductSalonModel.fromJson(data);
          if (productSalon.status == 0) {
            newOrders.add(productSalon);
          }
        });
        
        if (loadMore) {
          _productSalonList.addAll(newOrders);
        } else {
          _productSalonList = newOrders;
        }
        
        if (newOrders.length < _pageSize) {
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

  Future<void> getSalonOldList({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMoreOld || !_hasMoreOldData) return;
      _isLoadingMoreOld = true;
      _oldPage++;
    } else {
      _oldPage = 1;
      _hasMoreOldData = true;
      _productSalonListOld = [];
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
        List<ProductSalonModel> newOrders = [];
        body.forEach((data) {
          ProductSalonModel productSalon = ProductSalonModel.fromJson(data);
          if (productSalon.status != 0) {
            newOrders.add(productSalon);
          }
        });
        
        if (loadMore) {
          _productSalonListOld.addAll(newOrders);
        } else {
          _productSalonListOld = newOrders;
        }
        
        if (newOrders.length < _pageSize) {
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

  /// Load more new orders
  void loadMoreOrders() {
    if (parser.getType() == 'salon') {
      getSalonList(loadMore: true);
    } else {
      getIndividualOrdersList(loadMore: true);
    }
  }

  /// Load more old orders
  void loadMoreOldOrders() {
    if (parser.getType() == 'salon') {
      getSalonOldList(loadMore: true);
    } else {
      getIndividualOldOrdersList(loadMore: true);
    }
  }

  /// Refresh orders (pull to refresh)
  Future<void> refreshOrders() async {
    await getList();
  }

  void onProductDetail(int id) {
    Get.delete<ProductOrderDetailsController>(force: true);
    Get.toNamed(AppRouter.getProductOrderDetailsRoutes(), arguments: [id]);
  }
}
