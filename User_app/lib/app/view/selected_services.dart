import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/selected_services_controller.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class SelectedServicesScreen extends StatefulWidget {
  const SelectedServicesScreen({super.key});

  @override
  State<SelectedServicesScreen> createState() => _SelectedServicesScreenState();
}

class _SelectedServicesScreenState extends State<SelectedServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectedServicesController>(
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
            leading: IconButton(onPressed: () => value.onBack(), icon: const Icon(Icons.close), color: ThemeProvider.whiteColor),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: value.servicesList.length,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, i) => const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final bool selected = value.servicesList[i].isChecked ?? false;
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: ThemeProvider.cardDecoration().copyWith(
                                border: Border.all(color: selected ? ThemeProvider.appColor : ThemeProvider.borderColor, width: selected ? 1.4 : 1),
                              ),
                              child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(38),
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
                                        if ((value.servicesList[i].discount ?? 0) > 0)
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                              decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(10))),
                                              child: Text(
                                                '${value.servicesList[i].discount}%',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.whiteColor),
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
                                          Text(value.servicesList[i].name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.textPrimary)),
                                          const SizedBox(height: 4),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: Get.find<SelectedServicesController>().currencySide == 'left'
                                                      ? '${Get.find<SelectedServicesController>().currencySymbol} ${value.servicesList[i].price}'
                                                      : '${value.servicesList[i].price}${Get.find<SelectedServicesController>().currencySymbol}',
                                                  style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                                ),
                                                const TextSpan(text: '  '),
                                                TextSpan(
                                                  text: Get.find<SelectedServicesController>().currencySide == 'left'
                                                      ? '${Get.find<SelectedServicesController>().currencySymbol} ${value.servicesList[i].off}'
                                                      : '${value.servicesList[i].off}${Get.find<SelectedServicesController>().currencySymbol}',
                                                  style: const TextStyle(fontSize: 13, color: ThemeProvider.greenColor, fontFamily: 'bold'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              const Icon(Icons.schedule, size: 13, color: ThemeProvider.textSecondary),
                                              const SizedBox(width: 3),
                                              Text(
                                                '${value.servicesList[i].duration} ${'min'.tr}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: ThemeProvider.appColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      value: value.servicesList[i].isChecked,
                                      onChanged: (status) => value.updateServiceStatusInCart(i, status as bool),
                                    ),
                                  ],
                                ),
                              );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: Get.find<ServiceCartController>().totalItemsInCart > 0
              ? SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                      onTap: () => value.onCheckout(),
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value.currencySide == 'left'
                                  ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr}  ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
                                  : '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr}  ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
                              style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'medium', fontSize: 14),
                            ),
                            Text('Book Services'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
