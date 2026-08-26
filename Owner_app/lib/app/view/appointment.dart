import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/backend/models/appointment_model.dart';
import 'package:owner/app/controller/appointment_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            title: Text('Appointments History'.tr, style: ThemeProvider.titleStyle),
            bottom: TabBar(
              controller: value.tabController,
              unselectedLabelColor: ThemeProvider.whiteColor.withOpacity(0.65),
              labelColor: ThemeProvider.whiteColor,
              indicatorColor: ThemeProvider.whiteColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15),
              unselectedLabelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'New'.tr),
                Tab(text: 'Old'.tr),
              ],
            ),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : TabBarView(
                  controller: value.tabController,
                  children: [
                    _AppointmentList(
                      items: value.appointmentList,
                      value: value,
                      emptyMessage: 'No New Appointment Found!'.tr,
                    ),
                    _AppointmentList(
                      items: value.appointmentListOld,
                      value: value,
                      emptyMessage: 'No Past Appointment Found!'.tr,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _AppointmentList extends StatelessWidget {
  const _AppointmentList({required this.items, required this.value, required this.emptyMessage});

  final List<AppointmentModel> items;
  final AppointmentController value;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _AppointmentCard(item: items[index], value: value),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/no-data.png', width: 72, height: 72),
          const SizedBox(height: 18),
          Text(message, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.mutedTextColor)),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.item, required this.value});

  final AppointmentModel item;
  final AppointmentController value;

  String _money(num? amount) {
    final text = amount.toString();
    return value.currencySide == 'left' ? '${value.currencySymbol}$text' : '$text${value.currencySymbol}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = ThemeProvider.statusColor(item.status as int);
    final services = item.items!.services ?? [];
    final packages = item.items!.packages ?? [];

    return Material(
      color: ThemeProvider.whiteColor,
      borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
        onTap: () => value.onAppointment(item.id as int),
        child: Container(
          decoration: ThemeProvider.cardDecoration(),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage(
                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.userInfo!.cover.toString()}'),
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
                          '${item.userInfo!.firstName} ${item.userInfo!.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.appointmentsTo == 1 ? '${item.address!.house} ${item.address!.address} ${item.address!.landmark} ${item.address!.pincode}' : 'At Salon'.tr,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 12, color: ThemeProvider.mutedTextColor),
                        ),
                        const SizedBox(height: 3),
                        Text('${'Appointments ID #'.tr}${item.id}', style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                    child: Text(
                      value.statusName[item.status as int],
                      style: TextStyle(fontFamily: 'bold', fontSize: 10, color: statusColor),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: ThemeProvider.dividerColor)),
              if (services.isNotEmpty) ...[
                Text('Services'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 11, color: ThemeProvider.subtleTextColor)),
                const SizedBox(height: 6),
                ...services.map(
                  (service) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(service.name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor))),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: _money(service.price), style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor, decoration: TextDecoration.lineThrough)),
                              const TextSpan(text: '  '),
                              TextSpan(text: _money(service.off), style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor, fontFamily: 'bold')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (packages.isNotEmpty) ...[
                Text('Packages'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 11, color: ThemeProvider.subtleTextColor)),
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
                            Expanded(child: Text(package.name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor))),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: _money(package.price), style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor, decoration: TextDecoration.lineThrough)),
                                  const TextSpan(text: '  '),
                                  TextSpan(text: _money(package.off), style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor, fontFamily: 'bold')),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ...(package.services ?? []).map(
                          (packageService) => Padding(
                            padding: const EdgeInsets.only(left: 12, top: 2),
                            child: Text('•  ${packageService.name}', style: const TextStyle(fontSize: 11, color: ThemeProvider.mutedTextColor)),
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
                        Text('Grand Total'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                        Text(_money(item.grandTotal), style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.appColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event_outlined, size: 14, color: ThemeProvider.mutedTextColor),
                            const SizedBox(width: 4),
                            Text('Appointment at'.tr, style: const TextStyle(fontSize: 11, color: ThemeProvider.mutedTextColor)),
                          ],
                        ),
                        Text('${item.saveDate} ${item.slot}', style: const TextStyle(fontSize: 11, fontFamily: 'medium', color: ThemeProvider.blackColor)),
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
