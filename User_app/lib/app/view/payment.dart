import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/payment_controller.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/controller/slot_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _sectionTitleStyle = TextStyle(fontFamily: 'bold', fontSize: 15, color: ThemeProvider.textPrimary);
  static const _labelStyle = TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textSecondary);
  static const _valueStyle = TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.textPrimary);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Payment'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Offers & Benefits'.tr, style: _sectionTitleStyle),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: ThemeProvider.cardDecoration(),
                          child: InkWell(
                            onTap: () {
                              if (value.isWalletChecked == false) {
                                value.onCoupon(value.offerId, value.offerName);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                                      child: const Icon(Icons.local_offer_outlined, color: ThemeProvider.appColor, size: 18),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: value.offerName.isEmpty
                                          ? Text('Apply Coupon Code'.tr, overflow: TextOverflow.ellipsis, style: _valueStyle)
                                          : Text('Coupon Applied :'.tr + value.offerName, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.greenColor)),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.chevron_right, color: ThemeProvider.textSecondary),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: ThemeProvider.cardDecoration(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: ThemeProvider.appColor,
                                value: value.isWalletChecked,
                                onChanged: value.balance <= 0 || value.offerName.isNotEmpty ? null : (bool? status) => value.updateWalletChecked(status!),
                              ),
                              Expanded(
                                child: value.currencySide == 'left'
                                    ? Text('${'Available Balance'.tr + value.currencySymbol}${value.balance}', style: _valueStyle)
                                    : Text('${'Available Balance'.tr + value.balance.toString()}${value.currencySymbol}', style: _valueStyle),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Notes For Service'.tr, style: _sectionTitleStyle),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: ThemeProvider.cardDecoration(),
                          child: TextField(
                            controller: value.notesEditor,
                            maxLines: 4,
                            style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textPrimary),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ThemeProvider.transparent,
                              hintText: 'Appoinments notes'.tr,
                              hintStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(ThemeProvider.cardRadius), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ThemeProvider.cardRadius), borderSide: const BorderSide(color: ThemeProvider.appColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ThemeProvider.cardRadius), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Bill Details'.tr, style: _sectionTitleStyle),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: ThemeProvider.cardDecoration(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('item Total'.tr, overflow: TextOverflow.ellipsis, style: _labelStyle)),
                                    Text(
                                      value.currencySide == 'left'
                                          ? '${value.currencySymbol}${Get.find<ServiceCartController>().totalPrice.toString()}'
                                          : '${Get.find<ServiceCartController>().totalPrice.toString()}${value.currencySymbol}',
                                      style: _valueStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('item Discount'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.redColor, fontSize: 14, fontFamily: 'regular'))),
                                    Text(
                                      value.currencySide == 'left' ? '-${value.currencySymbol}${value.discount.toString()}' : '-${value.discount.toString()}${value.currencySymbol}',
                                      style: const TextStyle(color: ThemeProvider.redColor, fontFamily: 'medium', fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              value.isWalletChecked == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text('Wallet Discount'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.redColor, fontSize: 14, fontFamily: 'regular'))),
                                          Text(
                                            value.currencySide == 'left' ? '-${value.currencySymbol}${value.walletDiscount.toString()}' : '-${value.walletDiscount.toString()}${value.currencySymbol}',
                                            style: const TextStyle(color: ThemeProvider.redColor, fontFamily: 'medium', fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              value.appointmentsTo == 1
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text('Distance Charge'.tr, overflow: TextOverflow.ellipsis, style: _labelStyle)),
                                          Text(
                                            value.currencySide == 'left' ? '${value.currencySymbol}${value.deliveryPrice.toString()}' : '${value.deliveryPrice.toString()}${value.currencySymbol}',
                                            style: _valueStyle,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('Taxes & Charges'.tr, overflow: TextOverflow.ellipsis, style: _labelStyle)),
                                    Text(
                                      value.currencySide == 'left'
                                          ? '${value.currencySymbol}${Get.find<ServiceCartController>().orderTax.toString()}'
                                          : '${Get.find<ServiceCartController>().orderTax.toString()}${value.currencySymbol}',
                                      style: _valueStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(color: ThemeProvider.borderColor, height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text('To Pay'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 16))),
                                  Text(
                                    value.currencySide == 'left' ? '${value.currencySymbol}${value.grandTotal.toString()}' : '${value.grandTotal.toString()}${value.currencySymbol}',
                                    style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Payment Method'.tr, style: _sectionTitleStyle),
                        const SizedBox(height: 10),
                        value.paymentAPICalled == false ? SizedBox(height: 300, child: SkeletonListView(itemCount: 5)) : const SizedBox(),
                        Column(
                          children: List.generate(
                            value.paymentList.length,
                            (index) {
                              final bool isSelected = value.paymentList[index].id == value.paymentId;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                                  onTap: () => value.selectPaymentMethod(value.paymentList[index].id as int),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: ThemeProvider.surfaceColor,
                                      borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                                      boxShadow: ThemeProvider.cardShadow,
                                      border: Border.all(color: isSelected ? ThemeProvider.appColor : ThemeProvider.borderColor, width: isSelected ? 1.5 : 1),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(20),
                                            child: FadeInImage(
                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.paymentList[index].cover}'),
                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                              },
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(value.paymentList[index].name.toString(), style: const TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.textPrimary)),
                                        ),
                                        Icon(
                                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                                          color: isSelected ? ThemeProvider.appColor : ThemeProvider.borderColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: ThemeProvider.whiteColor,
              boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4))],
            ),
            height: 136,
            child: Column(
              children: [
                value.appointmentsTo == 1
                    ? ListTile(
                        onTap: () => value.onSelectAddress(),
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        leading: const Icon(Icons.location_on, size: 16, color: ThemeProvider.appColor),
                        minLeadingWidth: 0,
                        title: value.haveAddress == true
                            ? Text('${value.addressInfo.address} ${value.addressInfo.landmark}', style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary))
                            : Text('Please Add Your Address'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary)),
                        trailing: const Icon(Icons.edit_outlined, size: 14, color: ThemeProvider.textSecondary),
                      )
                    : const SizedBox(),
                value.apiCalled == true
                    ? ListTile(
                        onTap: () => value.onBack(),
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        leading: const Icon(Icons.access_time_sharp, size: 16, color: ThemeProvider.appColor),
                        minLeadingWidth: 0,
                        title: Text('${Get.find<SlotController>().savedDate} ${Get.find<SlotController>().selectedSlotIndex}', style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary)),
                        trailing: const Icon(Icons.edit_outlined, size: 14, color: ThemeProvider.textSecondary),
                      )
                    : const SizedBox(),
                value.haveFairDeliveryRadius == true
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () => value.onPayment(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeProvider.appColor,
                              shadowColor: ThemeProvider.appColor.withOpacity(0.3),
                              foregroundColor: ThemeProvider.whiteColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.all(0),
                            ),
                            child: Text(
                              value.currencySide == 'left' ? '${'Pay'} ${value.currencySymbol}${value.grandTotal}' : '${'Pay'} ${value.grandTotal}${value.currencySymbol}',
                              style: const TextStyle(letterSpacing: 1, fontSize: 16, color: ThemeProvider.whiteColor, fontFamily: 'bold'),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
