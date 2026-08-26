import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/categories_controller.dart';
import 'package:user/app/controller/product_cart_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('Categories'.tr, style: ThemeProvider.titleStyle),
          ),
          bottomNavigationBar: Get.find<ProductCartController>().savedInCart.isNotEmpty ? _buildCartBar(value) : const SizedBox(),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.productsList.isNotEmpty
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: List.generate(value.productsList.length, (index) => _buildCategoryCard(value, index)),
                      ),
                    )
                  : _buildEmptyState('No Data Found!'.tr),
        );
      },
    );
  }

  Widget _buildCartBar(CategoriesController value) {
    return SafeArea(
      top: false,
      child: InkWell(
        onTap: () => value.onCart(),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), boxShadow: ThemeProvider.cardShadow),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value.currencySide == 'left'
                    ? '${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ProductCartController>().totalPrice}'
                    : ' ${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} ${Get.find<ProductCartController>().totalPrice}${value.currencySymbol}',
                style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 13),
              ),
              Row(
                children: [
                  Text('Payments'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 13)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, color: ThemeProvider.whiteColor, size: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(CategoriesController value, int index) {
    final isExpanded = value.selectedCategory == value.productsList[index].id.toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ThemeProvider.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => value.onCategoryExpand(value.productsList[index].id.toString()),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: FadeInImage(
                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.productsList[index].cover.toString()}'),
                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [ThemeProvider.blackColor.withOpacity(0.0), ThemeProvider.blackColor.withOpacity(0.55)]),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          value.productsList[index].name.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 17),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: ThemeProvider.whiteColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: ThemeProvider.whiteColor, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded)
            Column(
              children: List.generate(
                value.productsList[index].subCates!.length,
                (subIndex) => InkWell(
                  onTap: () => value.onProducts(value.productsList[index].id as int, value.productsList[index].subCates![subIndex].id as int),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: ThemeProvider.borderColor, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            value.productsList[index].subCates![subIndex].name.toString(),
                            style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14, fontFamily: 'medium'),
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: ThemeProvider.textSecondary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.06)),
              child: const Icon(Icons.category_outlined, size: 40, color: ThemeProvider.appColor),
            ),
            const SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
          ],
        ),
      ),
    );
  }
}
