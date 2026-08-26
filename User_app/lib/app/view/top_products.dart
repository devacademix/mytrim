import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/product_cart_controller.dart';
import 'package:user/app/controller/top_products_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class TopProductScreen extends StatefulWidget {
  const TopProductScreen({super.key});

  @override
  State<TopProductScreen> createState() => _TopProductScreenState();
}

class _TopProductScreenState extends State<TopProductScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopProductsControllrer>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text('Top Products'.tr, style: ThemeProvider.titleStyle),
          ),
          bottomNavigationBar: Get.find<ProductCartController>().savedInCart.isNotEmpty
              ? SafeArea(
                  top: false,
                  child: Container(
                    decoration: BoxDecoration(color: ThemeProvider.surfaceColor, boxShadow: ThemeProvider.cardShadow),
                    child: InkWell(
                      onTap: () => value.onCart(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: const BoxDecoration(color: ThemeProvider.appColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${'Total'.tr} ${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} • ${Get.find<ProductCartController>().totalPrice}',
                              style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'medium', fontSize: 14),
                            ),
                            Row(
                              children: [
                                Text('Payments'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 14)),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_ios, color: ThemeProvider.whiteColor, size: 14),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          body: value.apiCalled == false
              ? SkeletonListView()
              : GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  crossAxisCount: 2,
                  childAspectRatio: 60 / 100,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(
                    value.productsList.length,
                    (i) {
                      return GestureDetector(
                        onTap: () => value.onProduct(value.productsList[i].id as int),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: ThemeProvider.cardDecoration(),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.productsList[i].cover.toString()}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', width: double.infinity, height: 120, fit: BoxFit.cover);
                                      },
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      value.productsList[i].name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'medium', fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.star, color: value.productsList[i].rating! >= 1 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                        Icon(Icons.star, color: value.productsList[i].rating! >= 2 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                        Icon(Icons.star, color: value.productsList[i].rating! >= 3 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                        Icon(Icons.star, color: value.productsList[i].rating! >= 4 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                        Icon(Icons.star, color: value.productsList[i].rating! >= 5 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                        const SizedBox(width: 6),
                                        Text(value.productsList[i].totalRating.toString(), style: const TextStyle(color: ThemeProvider.textSecondary, fontFamily: 'medium', fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          value.currencySide == 'left' ? '${value.currencySymbol}${value.productsList[i].originalPrice}/hr' : '${value.productsList[i].originalPrice}${value.currencySymbol}/hr',
                                          style: const TextStyle(decoration: TextDecoration.lineThrough, color: ThemeProvider.textSecondary, fontSize: 12),
                                        ),
                                        Text(
                                          value.currencySide == 'left' ? '${value.currencySymbol}${value.productsList[i].sellPrice}/hr' : '${value.productsList[i].sellPrice}${value.currencySymbol}/hr',
                                          style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    value.productsList[i].quantity == 0
                                        ? SizedBox(
                                            height: 28,
                                            width: 100,
                                            child: ElevatedButton(
                                              onPressed: () => value.addToCart(i),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: ThemeProvider.appColor,
                                                  foregroundColor: ThemeProvider.whiteColor,
                                                  elevation: 0,
                                                  shape: const StadiumBorder(),
                                                  padding: const EdgeInsets.all(0)),
                                              child: Text(
                                                'ADD'.tr,
                                                style: const TextStyle(letterSpacing: 1, fontSize: 12, color: ThemeProvider.whiteColor, fontFamily: 'bold'),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 28,
                                            padding: const EdgeInsets.symmetric(horizontal: 2),
                                            decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                                  onTap: () => value.updateProductQuantityRemove(i),
                                                  child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.remove, color: ThemeProvider.whiteColor, size: 14)),
                                                ),
                                                SizedBox(
                                                  width: 22,
                                                  child: Text(value.productsList[i].quantity.toString(),
                                                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontFamily: 'semibold', color: ThemeProvider.whiteColor)),
                                                ),
                                                InkWell(
                                                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                                  onTap: () => value.updateProductQuantity(i),
                                                  child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.add, color: ThemeProvider.whiteColor, size: 14)),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
