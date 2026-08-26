import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/product_order_details_controller.dart';
import 'package:owner/app/util/theme.dart';
import 'package:owner/app/env.dart';

// Mirrors the status labels used by HistoryController.statusName / AppointmentController.statusName
// so this detail screen's status chip matches the card list it was opened from.
const List<String> _kStatusLabelKeys = ['Created', 'Accepted', 'Rejected', 'Ongoing', 'Completed', 'Cancelled', 'Refunded', 'Delayed', 'Panding Payment'];

class ProductOrderDetailScreen extends StatefulWidget {
  const ProductOrderDetailScreen({super.key});

  @override
  State<ProductOrderDetailScreen> createState() => _ProductOrderDetailScreenState();
}

class _ProductOrderDetailScreenState extends State<ProductOrderDetailScreen> {
  String _money(ProductOrderDetailsController value, num? amount) {
    final text = amount.toString();
    return value.currencySide == 'left' ? '${value.currencySymbol}$text' : '$text${value.currencySymbol}';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductOrderDetailsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            title: Text("Order No #".tr + value.id.toString(), style: ThemeProvider.titleStyle),
            actions: <Widget>[
              IconButton(onPressed: () => value.launchInBrowser(), icon: const Icon(Icons.print_outlined, color: ThemeProvider.whiteColor)),
              IconButton(onPressed: () => value.openHelpModal(), icon: const Icon(Icons.question_mark_outlined, color: ThemeProvider.whiteColor)),
            ],
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FadeInImage(
                                  image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.productOrderDetails.userInfo!.cover.toString()}'),
                                  placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 44, width: 44);
                                  },
                                  fit: BoxFit.cover,
                                  height: 44,
                                  width: 44,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${value.productOrderDetails.userInfo!.firstName} ${value.productOrderDetails.userInfo!.lastName}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(value.productOrderDetails.userInfo!.email.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: ThemeProvider.mutedTextColor)),
                                    const SizedBox(height: 3),
                                    Text(value.productOrderDetails.userInfo!.mobile.toString(), style: const TextStyle(fontSize: 12, color: ThemeProvider.mutedTextColor)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: ThemeProvider.statusColor(value.productOrderDetails.status as int).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                ),
                                child: Text(
                                  _kStatusLabelKeys[value.productOrderDetails.status as int].tr,
                                  style: TextStyle(fontFamily: 'bold', fontSize: 10, color: ThemeProvider.statusColor(value.productOrderDetails.status as int)),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  value.onContactInfo('${value.productOrderDetails.userInfo!.firstName!} ${value.productOrderDetails.userInfo!.lastName!}', value.productOrderDetails.userInfo!.mobile!,
                                      value.productOrderDetails.userInfo!.email!, value.productOrderDetails.userInfo!.id.toString());
                                },
                                icon: const Icon(Icons.info_outline),
                                color: ThemeProvider.appColor,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SectionTitle(title: 'Delivery Address'),
                              const SizedBox(height: 6),
                              Text(
                                '${value.productOrderDetails.address!.house} ${value.productOrderDetails.address!.address} ${value.productOrderDetails.address!.landmark} ${value.productOrderDetails.address!.pincode}',
                                style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: ThemeProvider.dividerColor)),
                              _PriceRow(label: 'Order Date'.tr, value: value.productOrderDetails.createdAt.toString(), valueColor: ThemeProvider.blackColor),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SectionTitle(title: 'Orders'),
                              const SizedBox(height: 10),
                              ...List.generate(
                                value.productOrderDetails.orders!.length,
                                (subIndex) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${value.productOrderDetails.orders![subIndex].name} × ${value.productOrderDetails.orders![subIndex].quantity}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: _money(value, value.productOrderDetails.orders![subIndex].originalPrice),
                                              style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor, decoration: TextDecoration.lineThrough),
                                            ),
                                            const TextSpan(text: '  '),
                                            TextSpan(
                                              text: _money(value, value.productOrderDetails.orders![subIndex].sellPrice),
                                              style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor, fontFamily: 'bold'),
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
                        const SizedBox(height: 12),
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SectionTitle(title: 'Pricing'),
                              const SizedBox(height: 8),
                              _PriceRow(label: 'Discount'.tr, value: _money(value, value.productOrderDetails.discount)),
                              _PriceRow(label: 'Wallet Discount'.tr, value: _money(value, value.productOrderDetails.walletPrice)),
                              _PriceRow(label: 'Distance Cost'.tr, value: _money(value, value.productOrderDetails.deliveryCharge)),
                              _PriceRow(label: 'Service Tax'.tr, value: _money(value, value.productOrderDetails.tax)),
                              _PriceRow(label: 'Total'.tr, value: _money(value, value.productOrderDetails.total)),
                              _PriceRow(label: 'Payment'.tr, value: value.paymentName[value.productOrderDetails.paidMethod as int]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(ThemeProvider.cardRadius), border: Border.all(color: ThemeProvider.dividerColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Amount'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'bold', fontSize: 14)),
                              Text(
                                _money(value, value.productOrderDetails.grandTotal),
                                style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 18),
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
                  decoration: const BoxDecoration(color: ThemeProvider.whiteColor, boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -3))]),
                  child: SafeArea(
                    top: false,
                    child: value.productOrderDetails.status == 2 || value.productOrderDetails.status == 4 || value.productOrderDetails.status == 5 || value.productOrderDetails.status == 6
                        ? Text('${'Your Order Status'.tr} : ${value.orderStatus}', textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'medium', fontSize: 13, color: ThemeProvider.mutedTextColor))
                        : value.productOrderDetails.status == 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: ElevatedButton(
                                        onPressed: () => value.onUpdateAppointmentStatus(1),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: ThemeProvider.whiteColor,
                                          backgroundColor: ThemeProvider.appColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                          padding: const EdgeInsets.all(0),
                                        ),
                                        child: Text('Accept'.tr, style: const TextStyle(letterSpacing: 0.5, fontSize: 15, color: ThemeProvider.whiteColor, fontFamily: 'bold')),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: OutlinedButton(
                                        onPressed: () => value.onUpdateAppointmentStatus(2),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: ThemeProvider.mutedTextColor,
                                          side: const BorderSide(color: ThemeProvider.dividerColor),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                          padding: const EdgeInsets.all(0),
                                        ),
                                        child: Text('Decline'.tr, style: const TextStyle(letterSpacing: 0.5, fontSize: 15, fontFamily: 'bold')),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 44,
                                      decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), border: Border.all(color: ThemeProvider.dividerColor)),
                                      child: DropdownButton<String>(
                                        value: value.savedStatus,
                                        underline: const SizedBox(),
                                        iconSize: 22,
                                        icon: const Icon(Icons.keyboard_arrow_down),
                                        iconEnabledColor: ThemeProvider.mutedTextColor,
                                        style: const TextStyle(fontSize: 13, fontFamily: 'medium', color: ThemeProvider.blackColor),
                                        onChanged: (String? newValue) => value.onSelectStatus(newValue.toString()),
                                        items: value.selectStatus.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(value: value, child: Text(value));
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: ElevatedButton(
                                        onPressed: () => value.updateStatus(),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: ThemeProvider.whiteColor,
                                          backgroundColor: ThemeProvider.appColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                          padding: const EdgeInsets.all(0),
                                        ),
                                        child: Text('Update Status'.tr, style: const TextStyle(letterSpacing: 0.5, fontSize: 14, color: ThemeProvider.whiteColor, fontFamily: 'bold')),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: ThemeProvider.cardDecoration(), child: child);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'bold', fontSize: 13));
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value, this.valueColor = ThemeProvider.mutedTextColor});

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13)),
          Text(value, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end, style: TextStyle(color: valueColor, fontSize: 13, fontFamily: 'medium')),
        ],
      ),
    );
  }
}
