import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/individual_slot_controller.dart';
import 'package:user/app/util/theme.dart';

class IndividualSlotScreen extends StatefulWidget {
  const IndividualSlotScreen({super.key});

  @override
  State<IndividualSlotScreen> createState() => _IndividualSlotScreenState();
}

class _IndividualSlotScreenState extends State<IndividualSlotScreen> {
  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text(text, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.textPrimary))]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualSlotController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Slots'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('Select Date'.tr),
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: ThemeProvider.cardDecoration(),
                          child: DatePicker(
                            DateTime.now(),
                            width: 60,
                            height: 80,
                            controller: value.controller,
                            initialSelectedDate: DateTime.now(),
                            selectionColor: ThemeProvider.appColor,
                            selectedTextColor: Colors.white,
                            activeDates: List.generate(7, (index) => DateTime.now().add(Duration(days: index))),
                            onDateChange: (date) => value.onDateChange(date),
                          ),
                        ),
                        value.haveData == false
                            ? Center(child: Text('No Slots Found'.tr, style: const TextStyle(color: ThemeProvider.textSecondary)))
                            : _sectionLabel('Select Slots'.tr),
                        value.haveData == false
                            ? const SizedBox()
                            : Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: ThemeProvider.cardDecoration(),
                                child: Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  alignment: WrapAlignment.start,
                                  children: List.generate(
                                    value.slotList.slots!.length,
                                    (i) {
                                      final String slotKey = '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}';
                                      final bool booked = value.isBooked(slotKey);
                                      final bool selected = value.selectedSlotIndex == slotKey;
                                      return GestureDetector(
                                        onTap: () => value.onSelectSlot(slotKey),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: booked
                                                ? ThemeProvider.borderColor
                                                : selected
                                                    ? ThemeProvider.appColor
                                                    : ThemeProvider.surfaceTint,
                                            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                            border: Border.all(color: selected ? ThemeProvider.appColor : ThemeProvider.borderColor, width: 1),
                                          ),
                                          child: Text(
                                            '${value.slotList.slots![i].startTime} to ${value.slotList.slots![i].endTime}',
                                            style: TextStyle(
                                              color: booked
                                                  ? ThemeProvider.textSecondary
                                                  : selected
                                                      ? ThemeProvider.whiteColor
                                                      : ThemeProvider.textPrimary,
                                              fontFamily: selected ? 'bold' : 'regular',
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                onTap: () => value.onPayment(),
                child: Container(
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Make Payment'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 16))]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
