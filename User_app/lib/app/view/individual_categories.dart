import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/individual_categories_controller.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class IndividualCategoriesScreen extends StatefulWidget {
  const IndividualCategoriesScreen({super.key});

  @override
  State<IndividualCategoriesScreen> createState() => _IndividualCategoriesScreenState();
}

class _IndividualCategoriesScreenState extends State<IndividualCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text(value.selectedServiceName, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.servicesList.isNotEmpty
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: value.servicesList.length,
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, i) => Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: ThemeProvider.cardDecoration(),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(40),
                                            child: FadeInImage(
                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.servicesList[i].cover}'),
                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                              },
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        if (value.servicesList[i].discount != null)
                                          Positioned(
                                            top: 6,
                                            left: 6,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(color: ThemeProvider.redColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                              child: Text(
                                                '${value.servicesList[i].discount}%',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 10, color: ThemeProvider.whiteColor, fontFamily: 'semibold'),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  value.servicesList[i].name.toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.textPrimary),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: Checkbox(
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  checkColor: Colors.white,
                                                  activeColor: ThemeProvider.appColor,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                  value: value.servicesList[i].isChecked,
                                                  onChanged: (status) => value.updateServiceStatusInCart(i, status as bool),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '${value.servicesList[i].price} \$',
                                                  style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                                ),
                                                TextSpan(
                                                  text: '    ${value.servicesList[i].off}  \$',
                                                  style: const TextStyle(fontSize: 12, color: ThemeProvider.greenColor, fontFamily: 'semibold'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.access_time, size: 13, color: ThemeProvider.textSecondary),
                                              const SizedBox(width: 4),
                                              Text(
                                                value.servicesList[i].duration.toString() + ' min'.tr,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
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
                          ],
                        ),
                      ),
                    )
                  : _buildEmptyState('No Data Found!'.tr),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), boxShadow: ThemeProvider.cardShadow),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value.currencySide == 'left'
                            ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
                            : ' ${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
                        style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 13),
                      ),
                      Text('Book Services'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
              child: const Icon(Icons.design_services_outlined, size: 40, color: ThemeProvider.appColor),
            ),
            const SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
          ],
        ),
      ),
    );
  }
}
