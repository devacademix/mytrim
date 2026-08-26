import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/appointment_detail_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';

Color _statusColor(int status) {
  switch (status) {
    case 1:
      return ThemeProvider.appColor;
    case 2:
      return ThemeProvider.redColor;
    case 3:
      return ThemeProvider.orangeColor;
    case 4:
      return ThemeProvider.greenColor;
    case 5:
      return ThemeProvider.redColor;
    case 6:
      return ThemeProvider.secondaryAppColor;
    case 7:
      return ThemeProvider.orangeColor;
    case 8:
      return ThemeProvider.textSecondary;
    default:
      return ThemeProvider.secondaryAppColor;
  }
}

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key});

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  Widget _sectionCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: ThemeProvider.cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 14));
  }

  Widget _kvRow(String label, String value, {bool highlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(color: highlighted ? ThemeProvider.appColor : ThemeProvider.textPrimary, fontSize: 13, fontFamily: highlighted ? 'bold' : 'regular'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentDetailController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Appointment Detail'.tr, style: ThemeProvider.titleStyle),
            actions: <Widget>[IconButton(onPressed: () => value.launchInBrowser(), icon: const Icon(Icons.print_outlined)), IconButton(onPressed: () => value.openHelpModal(), icon: const Icon(Icons.question_mark_outlined))],
          ),
          body: value.apiCalled != true
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionCard(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(28),
                                    child: FadeInImage(
                                      image: NetworkImage(value.appointmentInfo.salonId != 0
                                          ? '${Environments.apiBaseURL}storage/images/${value.appointmentInfo.salonInfo!.cover.toString()}'
                                          : '${Environments.apiBaseURL}storage/images/${value.appointmentInfo.ownerInfo!.cover.toString()}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 30, width: 30);
                                      },
                                      fit: BoxFit.cover,
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        value.appointmentInfo.salonId != 0
                                            ? '${value.appointmentInfo.salonInfo!.name}'
                                            : '${value.appointmentInfo.ownerInfo!.firstName} ${value.appointmentInfo.ownerInfo!.lastName}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'bold', fontSize: 15, color: ThemeProvider.textPrimary),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        value.appointmentInfo.salonId != 0 ? value.appointmentInfo.salonInfo!.address.toString() : value.appointmentInfo.individualInfo!.address.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    if (value.appointmentInfo.salonId != 0) {
                                      value.onContactInfo(value.appointmentInfo.salonInfo!.name!, value.appointmentInfo.ownerInfo!.mobile!, value.appointmentInfo.ownerInfo!.email!, value.appointmentInfo.salonId.toString());
                                    } else {
                                      value.onContactInfo('${value.appointmentInfo.ownerInfo!.firstName!} ${value.appointmentInfo.ownerInfo!.lastName!}', value.appointmentInfo.ownerInfo!.mobile!,
                                          value.appointmentInfo.ownerInfo!.email!, value.appointmentInfo.freelancerId.toString());
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
                                    child: const Icon(Icons.info_outline, color: ThemeProvider.appColor, size: 18),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: ThemeProvider.borderColor)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Appoinments Status'.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _statusColor(value.appointmentInfo.status as int).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                  ),
                                  child: Text(
                                    value.orderStatus,
                                    style: TextStyle(fontFamily: 'bold', fontSize: 11, color: _statusColor(value.appointmentInfo.status as int)),
                                  ),
                                ),
                              ],
                            ),
                            if (value.haveSpecialist) ...[
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: ThemeProvider.borderColor)),
                              _sectionTitle('Specialist'.tr),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(16),
                                      child: FadeInImage(
                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.specialistCover}'),
                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 16, width: 16);
                                        },
                                        fit: BoxFit.cover,
                                        height: 16,
                                        width: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      value.specialistName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'bold', fontSize: 13, color: ThemeProvider.textPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        _sectionCard(
                          children: [
                            _sectionTitle('Booking Date & Time'.tr),
                            const SizedBox(height: 6),
                            _kvRow('Booking Date'.tr, value.savedDate, highlighted: true),
                            _kvRow('Booking Time'.tr, value.slot, highlighted: true),
                            if (value.notes.isNotEmpty && value.notes != 'NA') ...[
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: ThemeProvider.borderColor)),
                              _sectionTitle('Notes'.tr),
                              const SizedBox(height: 6),
                              Text(value.notes, style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary)),
                            ],
                          ],
                        ),
                        _sectionCard(
                          children: [
                            if (value.appointmentInfo.items!.services!.isNotEmpty) ...[
                              _sectionTitle('Services'.tr),
                              const SizedBox(height: 8),
                              ...List.generate(
                                value.appointmentInfo.items!.services!.length,
                                (serviceIndex) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          value.appointmentInfo.items!.services![serviceIndex].name.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontFamily: 'regular', fontSize: 12, color: ThemeProvider.textPrimary),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: value.currencySide == 'left'
                                                  ? value.currencySymbol + value.appointmentInfo.items!.services![serviceIndex].price.toString()
                                                  : value.appointmentInfo.items!.services![serviceIndex].price.toString() + value.currencySymbol,
                                              style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                            ),
                                            const TextSpan(text: '  '),
                                            TextSpan(
                                              text: value.currencySide == 'left'
                                                  ? value.currencySymbol + value.appointmentInfo.items!.services![serviceIndex].off.toString()
                                                  : value.appointmentInfo.items!.services![serviceIndex].off.toString() + value.currencySymbol,
                                              style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary, fontFamily: 'bold'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                            if (value.appointmentInfo.items!.packages!.isNotEmpty) ...[
                              _sectionTitle('Packages'.tr),
                              const SizedBox(height: 8),
                              ...List.generate(
                                value.appointmentInfo.items!.packages!.length,
                                (packageIndex) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              value.appointmentInfo.items!.packages![packageIndex].name.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontFamily: 'regular', fontSize: 12, color: ThemeProvider.textPrimary),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: value.currencySide == 'left'
                                                      ? value.currencySymbol + value.appointmentInfo.items!.packages![packageIndex].price.toString()
                                                      : value.appointmentInfo.items!.packages![packageIndex].price.toString() + value.currencySymbol,
                                                  style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                                ),
                                                const TextSpan(text: '  '),
                                                TextSpan(
                                                  text: value.currencySide == 'left'
                                                      ? value.currencySymbol + value.appointmentInfo.items!.packages![packageIndex].off.toString()
                                                      : value.appointmentInfo.items!.packages![packageIndex].off.toString() + value.currencySymbol,
                                                  style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary, fontFamily: 'bold'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ...List.generate(
                                        value.appointmentInfo.items!.packages![packageIndex].services!.length,
                                        (packageServiceIndex) => Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 2),
                                          child: Text(
                                            '-  ${value.appointmentInfo.items!.packages![packageIndex].services![packageServiceIndex].name}',
                                            style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        _sectionCard(
                          children: [
                            _sectionTitle('Pricing'.tr),
                            const SizedBox(height: 6),
                            _kvRow('Discount'.tr, value.currencySide == 'left' ? value.currencySymbol + value.discount.toString() : value.discount.toString() + value.currencySymbol),
                            _kvRow(
                                'Wallet Discount'.tr, value.currencySide == 'left' ? value.currencySymbol + value.walletDiscount.toString() : value.walletDiscount.toString() + value.currencySymbol),
                            _kvRow(
                                'Distance Cost'.tr, value.currencySide == 'left' ? value.currencySymbol + value.distanceCost.toString() : value.distanceCost.toString() + value.currencySymbol),
                            _kvRow('Service Tax'.tr, value.currencySide == 'left' ? value.currencySymbol + value.serviceTax.toString() : value.serviceTax.toString() + value.currencySymbol),
                            _kvRow('Total'.tr, value.currencySide == 'left' ? value.currencySymbol + value.total.toString() : value.total.toString() + value.currencySymbol),
                            _kvRow('Payment Method'.tr, value.paymentName[value.appointmentInfo.payMethod as int]),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Amount'.tr, style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'bold', fontSize: 14)),
                                  Text(
                                    value.currencySide == 'left' ? value.currencySymbol + value.grandTotal.toString() : value.grandTotal.toString() + value.currencySymbol,
                                    style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: value.apiCalled == false
              ? const SizedBox()
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: value.appointmentInfo.status == 1 ||
                          value.appointmentInfo.status == 2 ||
                          value.appointmentInfo.status == 3 ||
                          value.appointmentInfo.status == 7 ||
                          value.appointmentInfo.status == 8 ||
                          value.appointmentInfo.status == 5 ||
                          value.appointmentInfo.status == 6
                      ? Text('${'Your Appoinments Status'.tr} : ${value.orderStatus}', textAlign: TextAlign.center, style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13))
                      : value.appointmentInfo.status == 0
                          ? SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () => value.onUpdateAppointmentStatus(5),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeProvider.appColor,
                                    shadowColor: ThemeProvider.blackColor,
                                    foregroundColor: ThemeProvider.whiteColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                    padding: const EdgeInsets.all(0)),
                                child: Text(
                                  'Cancel'.tr,
                                  style: const TextStyle(letterSpacing: 1, fontSize: 16, color: ThemeProvider.whiteColor, fontFamily: 'bold'),
                                ),
                              ),
                            )
                          : value.appointmentInfo.status == 4
                              ? SizedBox(
                                  height: 65,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 46,
                                        child: ElevatedButton(
                                          onPressed: () => value.onAddReview(value.appointmentInfo.freelancerId as int),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ThemeProvider.appColor,
                                              shadowColor: ThemeProvider.blackColor,
                                              foregroundColor: ThemeProvider.whiteColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                              padding: const EdgeInsets.all(0)),
                                          child: Text(
                                            'Add Review'.tr,
                                            style: const TextStyle(letterSpacing: 1, fontSize: 16, color: ThemeProvider.whiteColor, fontFamily: 'bold'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                ),
        );
      },
    );
  }
}
