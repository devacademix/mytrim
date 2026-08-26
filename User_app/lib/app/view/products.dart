import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/product_cart_controller.dart';
import 'package:user/app/controller/products_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Products'.tr, style: ThemeProvider.titleStyle),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(color: ThemeProvider.surfaceColor, boxShadow: ThemeProvider.cardShadow),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => value.onSortBy(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.sort, color: ThemeProvider.textSecondary, size: 20),
                          const SizedBox(width: 6),
                          Text('Sort By'.tr, style: const TextStyle(color: ThemeProvider.textSecondary, fontFamily: 'medium', fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => value.onCart(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: const BoxDecoration(color: ThemeProvider.appColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value.currencySide == 'left'
                                ? '${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} • ${value.currencySymbol} ${Get.find<ProductCartController>().totalPrice}'
                                : '${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} • ${Get.find<ProductCartController>().totalPrice}${value.currencySymbol}',
                            style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'medium', fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text('Book Services'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 14)),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, color: ThemeProvider.whiteColor, size: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.productsList.isNotEmpty
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        children: List.generate(
                          value.productsList.length,
                          (index) => Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: ThemeProvider.cardDecoration(),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                              onTap: () => value.onProductsDetails(value.productsList[index].id as int),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: SizedBox(
                                      width: 78,
                                      height: 78,
                                      child: FadeInImage(
                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.productsList[index].cover.toString()}'),
                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(value.productsList[index].name.toString(),
                                            overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
                                        const SizedBox(height: 3),
                                        Text(
                                          value.productsList[index].descriptions.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12, height: 1.4),
                                        ),
                                        const SizedBox(height: 6),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: Get.find<ProductsController>().currencySide == 'left'
                                                    ? '${Get.find<ProductsController>().currencySymbol} ${value.productsList[index].sellPrice}'
                                                    : '${value.productsList[index].sellPrice}${Get.find<ProductsController>().currencySymbol}',
                                                style: const TextStyle(fontSize: 14, color: ThemeProvider.appColor, fontFamily: 'bold'),
                                              ),
                                              const TextSpan(text: '  '),
                                              TextSpan(
                                                text: Get.find<ProductsController>().currencySide == 'left'
                                                    ? '${Get.find<ProductsController>().currencySymbol} ${value.productsList[index].originalPrice}'
                                                    : '${value.productsList[index].originalPrice}${Get.find<ProductsController>().currencySymbol}',
                                                style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                              ),
                                              TextSpan(
                                                text: '   ${value.productsList[index].discount}% ${'off'.tr}',
                                                style: const TextStyle(fontSize: 12, color: ThemeProvider.greenColor, fontFamily: 'semibold'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                                                ],
                                              ),
                                            ),
                                            value.productsList[index].quantity == 0
                                                ? SizedBox(
                                                    height: 30,
                                                    child: ElevatedButton(
                                                      onPressed: () => value.addToCart(index),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: ThemeProvider.appColor,
                                                        elevation: 0,
                                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                                        shape: const StadiumBorder(),
                                                      ),
                                                      child: Text('Add'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 13)),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 30,
                                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                                    decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        InkWell(
                                                          borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                                          onTap: () => value.updateProductQuantityRemove(index),
                                                          child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.remove, color: ThemeProvider.whiteColor, size: 15)),
                                                        ),
                                                        SizedBox(
                                                          width: 24,
                                                          child: Text(value.productsList[index].quantity.toString(),
                                                              textAlign: TextAlign.center, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 13)),
                                                        ),
                                                        InkWell(
                                                          borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                                          onTap: () => value.updateProductQuantity(index),
                                                          child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.add, color: ThemeProvider.whiteColor, size: 15)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.08)),
                            child: const Icon(Icons.shopping_bag_outlined, size: 40, color: ThemeProvider.appColor),
                          ),
                          const SizedBox(height: 20),
                          Text('No Data Found!'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
                          const SizedBox(height: 6),
                          Text('Check back later for new products'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 13, color: ThemeProvider.textSecondary)),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
