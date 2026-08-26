import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:owner/app/backend/models/appointment_model.dart';
import 'package:owner/app/controller/calendar_controller.dart';
import 'package:owner/app/util/theme.dart';
import 'package:owner/app/env.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    _calendarController.selectedDate = DateTime.now();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            toolbarHeight: 50,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            automaticallyImplyLeading: false,
            title: Text('Calendar'.tr, style: ThemeProvider.titleStyle),
            bottom: value.apiCalled == true
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(300),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: ThemeProvider.whiteColor,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                        boxShadow: ThemeProvider.cardShadow,
                      ),
                      child: _getAgendaViewCalendar(value.events, _onViewChanged, _calendarController),
                    ),
                  )
                : null,
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : value.calendarListCalled == false
                  ? SkeletonListView()
                  : value.appointmentList.isEmpty
                      ? _EmptyState(message: 'No Appointment Found!'.tr)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                          itemCount: value.appointmentList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) => _DayAppointmentCard(item: value.appointmentList[index], value: value),
                        ),
        );
      },
    );
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final DateTime currentViewDate = visibleDatesChangedDetails.visibleDates[visibleDatesChangedDetails.visibleDates.length ~/ 2];

      if (currentViewDate.month == DateTime.now().month && currentViewDate.year == DateTime.now().year) {
        _calendarController.selectedDate = DateTime.now();
      } else {
        _calendarController.selectedDate = DateTime(currentViewDate.year, currentViewDate.month);
      }
    });
    _calendarController.addPropertyChangedListener((event) {
      debugPrint(_calendarController.selectedDate.toString());
      Get.find<CalendarsController>().getByDate(_calendarController.selectedDate.toString());
    });
  }

  SfCalendar _getAgendaViewCalendar([CalendarDataSource? calendarDataSource, ViewChangedCallback? onViewChanged, CalendarController? controller]) {
    return SfCalendar(
      view: CalendarView.month,
      controller: controller,
      showDatePickerButton: true,
      onViewChanged: onViewChanged,
      backgroundColor: ThemeProvider.whiteColor,
      dataSource: calendarDataSource,
      todayHighlightColor: ThemeProvider.appColor,
      cellBorderColor: ThemeProvider.dividerColor,
      headerStyle: const CalendarHeaderStyle(backgroundColor: ThemeProvider.whiteColor, textStyle: TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor)),
      viewHeaderStyle: const ViewHeaderStyle(backgroundColor: ThemeProvider.whiteColor, dayTextStyle: TextStyle(fontFamily: 'medium', fontSize: 11, color: ThemeProvider.subtleTextColor)),
      selectionDecoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), border: Border.all(color: ThemeProvider.appColor, width: 1.5), borderRadius: BorderRadius.circular(8)),
      monthViewSettings: const MonthViewSettings(
        showAgenda: false,
        numberOfWeeksInView: 4,
        monthCellStyle: MonthCellStyle(
          backgroundColor: ThemeProvider.whiteColor,
          trailingDatesBackgroundColor: ThemeProvider.surfaceTint,
          leadingDatesBackgroundColor: ThemeProvider.surfaceTint,
          textStyle: TextStyle(fontSize: 12, color: ThemeProvider.blackColor),
          trailingDatesTextStyle: TextStyle(fontSize: 12, color: ThemeProvider.subtleTextColor),
          leadingDatesTextStyle: TextStyle(fontSize: 12, color: ThemeProvider.subtleTextColor),
        ),
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(minimumAppointmentDuration: Duration(minutes: 60)),
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

// Mirrors the status labels used by AppointmentController.statusName so the
// day-agenda card can show the same status chip as appointment.dart.
const List<String> _kStatusLabelKeys = ['Created', 'Accepted', 'Rejected', 'Ongoing', 'Completed', 'Cancelled', 'Refunded', 'Delayed', 'Panding Payment'];

class _DayAppointmentCard extends StatelessWidget {
  const _DayAppointmentCard({required this.item, required this.value});

  final AppointmentModel item;
  final CalendarsController value;

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
                      _kStatusLabelKeys[item.status as int].tr,
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
