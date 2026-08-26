import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/product_order_detail_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/env.dart';

Color _statusColor(int status) {
  switch (status) {
    case 0:
      return ThemeProvider.orangeColor;
    case 1:
      return ThemeProvider.secondaryAppColor;
    case 2:
      return ThemeProvider.redColor;
    case 3:
      return ThemeProvider.appColor;
    case 4:
      return ThemeProvider.greenColor;
    case 5:
      return ThemeProvider.redColor;
    case 6:
      return ThemeProvider.textSecondary;
    case 7:
      return ThemeProvider.orangeColor;
    default:
      return ThemeProvider.orangeColor;
  }
}

class ProductOrderDetail extends StatefulWidget {
  const ProductOrderDetail({super.key});

  @override
  State<ProductOrderDetail> createState() => _ProductOrderDetailState();
}

class _ProductOrderDetailState extends State<ProductOrderDetail> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductOrderDetailController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Order Detail'.tr, style: ThemeProvider.titleStyle),
            actions: <Widget>[
              IconButton(onPressed: () => value.launchInBrowser(), icon: const Icon(Icons.print_outlined)),
              IconButton(onPressed: () => value.openHelpModal(), icon: const Icon(Icons.question_mark_outlined)),
            ],
          ),
          body: value.apiCalled != true
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Salon / freelancer header card.
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: ThemeProvider.cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              value.salonOrderInfo.type == 'salon'
                                  ? Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: SizedBox(
                                            height: 52,
                                            width: 52,
                                            child: FadeInImage(
                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.salonOrderInfo.salonInfo!.cover.toString()}'),
                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 52, width: 52);
                                              },
                                              fit: BoxFit.cover,
                                              height: 52,
                                              width: 52,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${value.salonOrderInfo.salonInfo!.name}', overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'bold', fontSize: 15, color: ThemeProvider.textPrimary)),
                                              const SizedBox(height: 4),
                                              Text(value.fullAddres.toString(), overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                            ],
                                          ),
                                        ),
                                        _ContactButton(
                                          onTap: () =>
                                              value.onContactInfo(value.salonOrderInfo.salonInfo!.name!, value.salonOrderInfo.ownerInfo!.mobile!, value.salonOrderInfo.ownerInfo!.email!, value.salonOrderInfo.salonId.toString()),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: SizedBox(
                                            height: 52,
                                            width: 52,
                                            child: FadeInImage(
                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.salonOrderInfo.ownerInfo!.cover.toString()}'),
                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 52, width: 52);
                                              },
                                              fit: BoxFit.cover,
                                              height: 52,
                                              width: 52,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${value.salonOrderInfo.ownerInfo!.firstName} ${value.salonOrderInfo.ownerInfo!.lastName}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontFamily: 'bold', fontSize: 15, color: ThemeProvider.textPrimary),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(value.fullAddres.toString(), overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                            ],
                                          ),
                                        ),
                                        _ContactButton(
                                          onTap: () {
                                            value.onContactInfo('${value.salonOrderInfo.ownerInfo!.firstName!} ${value.salonOrderInfo.ownerInfo!.lastName!}', value.salonOrderInfo.ownerInfo!.mobile!,
                                                value.salonOrderInfo.ownerInfo!.email!, value.salonOrderInfo.freelancerId.toString());
                                          },
                                        ),
                                      ],
                                    ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, color: ThemeProvider.borderColor)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.event_outlined, size: 15, color: ThemeProvider.textSecondary),
                                      const SizedBox(width: 6),
                                      Text('Order At'.tr, style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13, fontFamily: 'medium')),
                                    ],
                                  ),
                                  Text(value.createdAt, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 13, fontFamily: 'bold')),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: _statusColor(value.salonOrderInfo.status ?? 0).withOpacity(0.12), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                child: Text(value.orderStatus, style: TextStyle(fontFamily: 'bold', fontSize: 11, color: _statusColor(value.salonOrderInfo.status ?? 0))),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Ordered items card.
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: ThemeProvider.cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Orders'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 15)),
                              const SizedBox(height: 10),
                              ...List.generate(
                                value.salonOrderInfo.orders!.length,
                                (subIndex) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${value.salonOrderInfo.orders![subIndex].name} ${'X'.tr} ${value.salonOrderInfo.orders![subIndex].quantity}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13, color: ThemeProvider.textPrimary),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: value.currencySide == 'left'
                                                  ? value.currencySymbol + value.salonOrderInfo.orders![subIndex].originalPrice.toString()
                                                  : value.salonOrderInfo.orders![subIndex].originalPrice.toString() + value.currencySymbol,
                                              style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                            ),
                                            const TextSpan(text: '  '),
                                            TextSpan(
                                              text: value.currencySide == 'left'
                                                  ? value.currencySymbol + value.salonOrderInfo.orders![subIndex].sellPrice.toString()
                                                  : value.salonOrderInfo.orders![subIndex].sellPrice.toString() + value.currencySymbol,
                                              style: const TextStyle(fontSize: 13, color: ThemeProvider.textPrimary, fontFamily: 'bold'),
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
                        const SizedBox(height: 14),
                        // Pricing breakdown card.
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: ThemeProvider.cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pricing'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 15)),
                              const SizedBox(height: 10),
                              _PriceRow(label: 'Discount'.tr, value: value.currencySide == 'left' ? value.currencySymbol + value.discount.toString() : value.discount.toString() + value.currencySymbol),
                              _PriceRow(
                                  label: 'Wallet Discount'.tr,
                                  value: value.currencySide == 'left' ? value.currencySymbol + value.walletDiscount.toString() : value.walletDiscount.toString() + value.currencySymbol),
                              _PriceRow(
                                  label: 'Distance Cost'.tr, value: value.currencySide == 'left' ? value.currencySymbol + value.distanceCost.toString() : value.distanceCost.toString() + value.currencySymbol),
                              _PriceRow(label: 'Service Tax'.tr, value: value.currencySide == 'left' ? value.currencySymbol + value.serviceTax.toString() : value.serviceTax.toString() + value.currencySymbol),
                              _PriceRow(label: 'Total'.tr, value: value.currencySide == 'left' ? value.currencySymbol + value.total.toString() : value.total.toString() + value.currencySymbol),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Amount'.tr, style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14, fontFamily: 'bold')),
                                    Text(
                                      value.currencySide == 'left' ? value.currencySymbol + value.grandTotal.toString() : value.grandTotal.toString() + value.currencySymbol,
                                      style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 16),
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
          bottomNavigationBar: value.apiCalled == false
              ? const SizedBox()
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: value.salonOrderInfo.status == 1 ||
                          value.salonOrderInfo.status == 2 ||
                          value.salonOrderInfo.status == 3 ||
                          value.salonOrderInfo.status == 7 ||
                          value.salonOrderInfo.status == 8 ||
                          value.salonOrderInfo.status == 5 ||
                          value.salonOrderInfo.status == 6
                      ? Text('${'Your Order Status'.tr} : ${value.orderStatus}', textAlign: TextAlign.center, style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13, fontFamily: 'medium'))
                      : value.salonOrderInfo.status == 0
                          ? SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () => value.onUpdateAppointmentStatus(5),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeProvider.appColor,
                                  shadowColor: ThemeProvider.transparent,
                                  foregroundColor: ThemeProvider.whiteColor,
                                  elevation: 0,
                                  shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius))),
                                  padding: const EdgeInsets.all(0),
                                ),
                                child: Text('Cancel'.tr, style: const TextStyle(letterSpacing: 0.5, fontSize: 15, color: ThemeProvider.whiteColor, fontFamily: 'bold')),
                              ),
                            )
                          : value.salonOrderInfo.status == 4
                              ? SizedBox(
                                  width: double.infinity,
                                  height: 46,
                                  child: ElevatedButton(
                                    onPressed: () => value.onAddReview(value.salonOrderInfo.freelancerId as int),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeProvider.appColor,
                                      shadowColor: ThemeProvider.transparent,
                                      foregroundColor: ThemeProvider.whiteColor,
                                      elevation: 0,
                                      shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius))),
                                      padding: const EdgeInsets.all(0),
                                    ),
                                    child: Text('Add Review'.tr, style: const TextStyle(letterSpacing: 0.5, fontSize: 15, color: ThemeProvider.whiteColor, fontFamily: 'bold')),
                                  ),
                                )
                              : const SizedBox(),
                ),
        );
      },
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), shape: BoxShape.circle),
        child: const Icon(Icons.info_outline, color: ThemeProvider.appColor, size: 20),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13)),
          Text(value, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 13, fontFamily: 'medium')),
        ],
      ),
    );
  }
}
