import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/models/appointment_model.dart';
import 'package:user/app/controller/booking_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

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

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            title: Text('Appointments History'.tr, style: ThemeProvider.titleStyle),
            bottom: value.parser.haveLoggedIn() == true
                ? TabBar(
                    controller: value.tabController,
                    unselectedLabelColor: ThemeProvider.whiteColor.withOpacity(0.65),
                    labelColor: ThemeProvider.whiteColor,
                    indicatorColor: ThemeProvider.whiteColor,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15, color: ThemeProvider.whiteColor),
                    unselectedLabelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15, color: ThemeProvider.whiteColor),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: const EdgeInsets.all(8),
                    tabs: [
                      Text('New'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
                      Text('Old'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
                    ],
                  )
                : null,
          ),
          body: value.parser.haveLoggedIn() == true
              ? value.apiCalled == false
                  ? SkeletonListView()
                  : TabBarView(
                      controller: value.tabController,
                      children: [
                        _buildAppointmentList(value, value.appointmentList, 'No New Appointment Found!'.tr, (id) => value.onAppointment(id)),
                        _buildAppointmentList(value, value.appointmentListOld, 'No Past Appointment Found!'.tr, (id) => value.onAppointment(id)),
                      ],
                    )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/no-data.png', width: 60, height: 60),
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () => value.onLoginRoutes(),
                        child: Text('Opps, Please Login or Register first!'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.appColor)),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildAppointmentList(BookingController value, List<AppointmentModel> items, String emptyMessage, void Function(int id) onTapItem) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/no-data.png', width: 60, height: 60),
            const SizedBox(height: 20),
            Text(emptyMessage, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.textSecondary)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildAppointmentCard(value, items[index], onTapItem),
    );
  }

  Widget _buildAppointmentCard(BookingController value, AppointmentModel item, void Function(int id) onTapItem) {
    final statusColor = _statusColor(item.status as int);
    final services = item.items!.services ?? [];
    final packages = item.items!.packages ?? [];
    final bool isSalon = item.salonId != 0;

    String money(Object? amount) => value.currencySide == 'left' ? '${value.currencySymbol}$amount' : '$amount${value.currencySymbol}';

    return Material(
      color: ThemeProvider.transparent,
      borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
        onTap: () => onTapItem(item.id as int),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: ThemeProvider.cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage(
                      image: NetworkImage(isSalon
                          ? '${Environments.apiBaseURL}storage/images/${item.salonInfo!.cover.toString()}'
                          : '${Environments.apiBaseURL}storage/images/${item.individualInfo!.background.toString()}'),
                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                      imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 44, width: 44),
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
                          isSalon ? item.salonInfo!.name.toString() : '${item.individualInfo!.firstName} ${item.individualInfo!.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.textPrimary),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isSalon ? item.salonInfo!.address.toString() : item.individualInfo!.address.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                    child: Text(
                      value.statusName[item.status as int].tr,
                      style: TextStyle(fontFamily: 'bold', fontSize: 10, color: statusColor),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: ThemeProvider.borderColor)),
              if (services.isNotEmpty) ...[
                Text('Services'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 11, color: ThemeProvider.textSecondary)),
                const SizedBox(height: 6),
                ...services.map(
                  (service) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(service.name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary))),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: money(service.price), style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough)),
                              const TextSpan(text: '  '),
                              TextSpan(text: money(service.off), style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary, fontFamily: 'bold')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (packages.isNotEmpty) ...[
                Text('Packages'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 11, color: ThemeProvider.textSecondary)),
                const SizedBox(height: 6),
                ...packages.map(
                  (package) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(package.name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary))),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: money(package.price), style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough)),
                                  const TextSpan(text: '  '),
                                  TextSpan(text: money(package.off), style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary, fontFamily: 'bold')),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ...(package.services ?? []).map(
                          (packageService) => Padding(
                            padding: const EdgeInsets.only(left: 12, top: 2),
                            child: Text('-  ${packageService.name}', style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Grand Total :'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'bold', color: ThemeProvider.textPrimary)),
                        Text(money(item.grandTotal), style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.appColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event_outlined, size: 14, color: ThemeProvider.textSecondary),
                            const SizedBox(width: 4),
                            Text('Appointment at :'.tr, style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary)),
                          ],
                        ),
                        Text('${item.saveDate} ${item.slot}', style: const TextStyle(fontSize: 11, fontFamily: 'medium', color: ThemeProvider.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
