import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:owner/app/backend/api/handler.dart';
import 'package:owner/app/backend/models/products_model.dart';
import 'package:owner/app/backend/parse/products_parse.dart';
import 'package:owner/app/controller/create_products_controller.dart';
import 'package:owner/app/helper/router.dart';
import 'package:owner/app/util/constance.dart';
import 'package:owner/app/util/toast.dart';

class ProductsController extends GetxController implements GetxService {
  final ProductsParser parser;

  bool apiCalled = false;

  List<ProductsModel> _productsInfo = <ProductsModel>[];
  List<ProductsModel> get productsInfo => _productsInfo;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  // Pagination variables
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;

  ProductsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getProductWFreelancer();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
  }

  Future<void> getProductWFreelancer({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasMoreData) return;
      _isLoadingMore = true;
      _currentPage++;
    } else {
      _currentPage = 1;
      _hasMoreData = true;
      _productsInfo = [];
    }

    update();

    var param = {"id": parser.getFreelancerId()};
    apiCalled = true;
    Response response = await parser.getProductWFreelancer(param, page: _currentPage, limit: _pageSize);
    debugPrint(response.bodyString);
    
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var product = myMap['data'];
      
      if (product == null || (product is List && product.isEmpty)) {
        _hasMoreData = false;
      } else {
        List<ProductsModel> newProducts = [];
        product.forEach((data) {
          ProductsModel datas = ProductsModel.fromJson(data);
          newProducts.add(datas);
        });
        
        if (loadMore) {
          _productsInfo.addAll(newProducts);
        } else {
          _productsInfo = newProducts;
        }
        
        // Check if we got fewer items than requested
        if (newProducts.length < _pageSize) {
          _hasMoreData = false;
        }
      }
      
      debugPrint('Products count: ${productsInfo.length}');
    } else {
      ApiChecker.checkApi(response);
      if (loadMore) {
        _currentPage--; // Revert page increment on error
      }
    }
    
    _isLoadingMore = false;
    update();
  }

  /// Load more products
  void loadMoreProducts() {
    getProductWFreelancer(loadMore: true);
  }

  /// Refresh products (pull to refresh)
  Future<void> refreshProducts() async {
    await getProductWFreelancer();
  }

  Future<void> destroyProduct(int id) async {
    var param = {"id": id};
    var response = await parser.destroyProduct(param);
    if (response.statusCode == 200) {
      getProductWFreelancer();
      showToast('item remove successfully');
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> updateStatus(int id, int status) async {
    var body = {"status": status == 1 ? 0 : 1, "id": id};
    var response = await parser.onUpdateProducts(body);
    if (response.statusCode == 200) {
      debugPrint(response.bodyString);
      successToast('Updated');
      getProductWFreelancer();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void onCreateProducts() {
    Get.delete<CreateProductsController>(force: true);
    Get.toNamed(AppRouter.getCreateProductsRoute(), arguments: ['create']);
  }

  void onUpdateProducts(int id) {
    Get.delete<CreateProductsController>(force: true);
    Get.toNamed(AppRouter.getCreateProductsRoute(), arguments: ['update', id]);
  }
}
