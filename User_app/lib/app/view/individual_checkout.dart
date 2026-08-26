import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/individual_checkout_controller.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';

class IndividualCheckoutScreen extends StatefulWidget {
  const IndividualCheckoutScreen({super.key});

  @override
  State<IndividualCheckoutScreen> createState() => _IndividualCheckoutScreenState();
}

class _IndividualCheckoutScreenState extends State<IndividualCheckoutScreen> {
  Widget _sectionHeader(String left, String right) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(left, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
            Text(right, style: const TextStyle(fontFamily: 'medium', fontSize: 13, color: ThemeProvider.textSecondary)),
          ],
        ),
      );

  Widget _billRow(String label, String value, {bool highlight = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontFamily: highlight ? 'semibold' : 'regular', color: highlight ? ThemeProvider.appColor : ThemeProvider.textSecondary)),
            ),
            Text(value, style: TextStyle(fontSize: 14, fontFamily: highlight ? 'bold' : 'medium', color: highlight ? ThemeProvider.appColor : ThemeProvider.textPrimary)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualCheckoutController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Checkout'.tr, style: ThemeProvider.titleStyle),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                children: [
                  value.savedInCart.services!.isNotEmpty ? _sectionHeader('Total'.tr, '${value.savedInCart.services!.length} ${'Services'.tr}') : const SizedBox(),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: value.savedInCart.services!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) => Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: ThemeProvider.cardDecoration(),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                              width: 72,
                              height: 72,
                              child: FadeInImage(
                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.savedInCart.services![i].cover}'),
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
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: InkWell(
                                    onTap: () => value.deleteServiceFromCart(i),
                                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                    child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.delete_outline, color: ThemeProvider.redColor, size: 20)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(value.savedInCart.services![i].name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.textPrimary)),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: value.currencySide == 'left' ? '${value.currencySymbol} ${value.savedInCart.services![i].price}' : ' ${value.savedInCart.services![i].price}${value.currencySymbol}',
                                              style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                            ),
                                            TextSpan(
                                              text: value.currencySide == 'left' ? '  ${value.currencySymbol} ${value.savedInCart.services![i].off}' : '  ${value.savedInCart.services![i].off}${value.currencySymbol}',
                                              style: const TextStyle(fontSize: 12, color: ThemeProvider.greenColor, fontFamily: 'bold'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        value.savedInCart.services![i].duration.toString() + 'min'.tr,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
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
                  ),
                  value.savedInCart.packages!.isNotEmpty ? _sectionHeader('Total'.tr, '${value.savedInCart.packages!.length} ${'Packages'.tr}') : const SizedBox(),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: value.savedInCart.packages!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) => Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: ThemeProvider.cardDecoration(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                              width: 72,
                              height: 72,
                              child: FadeInImage(
                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.savedInCart.packages![i].cover}'),
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
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: InkWell(
                                    onTap: () => value.deletePackageFromCart(i),
                                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                    child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.delete_outline, color: ThemeProvider.redColor, size: 20)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(value.savedInCart.packages![i].name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.textPrimary)),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                          value.savedInCart.packages![i].services!.length,
                                          (serviceIndex) => Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Text(
                                              '•  ${value.savedInCart.packages![i].services![serviceIndex].name}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: value.currencySide == 'left' ? '${value.currencySymbol} ${value.savedInCart.packages![i].price}' : ' ${value.savedInCart.packages![i].price}${value.currencySymbol}',
                                              style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                            ),
                                            TextSpan(
                                              text: value.currencySide == 'left' ? '  ${value.currencySymbol} ${value.savedInCart.packages![i].off}' : '  ${value.savedInCart.packages![i].off}${value.currencySymbol}',
                                              style: const TextStyle(fontSize: 12, fontFamily: 'bold', color: ThemeProvider.greenColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        value.savedInCart.packages![i].duration.toString() + 'min'.tr,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('Bill Details'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary))]),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: ThemeProvider.cardDecoration(),
                    child: Column(
                      children: [
                        _billRow('item Total'.tr, value.currencySide == 'left' ? '${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}' : ' ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}'),
                        _billRow('Taxes & Charges'.tr, value.currencySide == 'left' ? '${value.currencySymbol} ${Get.find<ServiceCartController>().orderTax}' : ' ${Get.find<ServiceCartController>().orderTax}${value.currencySymbol}'),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(color: ThemeProvider.borderColor, height: 1)),
                        _billRow('To Pay'.tr, value.currencySide == 'left' ? '${value.currencySymbol} ${Get.find<ServiceCartController>().grandTotal}' : ' ${Get.find<ServiceCartController>().grandTotal}${value.currencySymbol}', highlight: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => value.onSlot(),
                  style: ElevatedButton.styleFrom(backgroundColor: ThemeProvider.appColor, elevation: 0, shape: const StadiumBorder()),
                  child: Text('Select Date & Time'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 16)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
