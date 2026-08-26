import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:user/app/controller/slot_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';

class SlotScreen extends StatefulWidget {
  const SlotScreen({super.key});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text(text, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.textPrimary))]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SlotController>(
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
                          height: 120,
                          margin: const EdgeInsets.only(bottom: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: ThemeProvider.cardDecoration(),
                          child: DatePicker(
                            DateTime.now(),
                            width: 60,
                            height: 90,
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
                                margin: const EdgeInsets.only(bottom: 18),
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
                        _sectionLabel('Select Specialist'.tr),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              value.specialistList.length,
                              (index) {
                                final bool selected = value.selectedSpecialist == value.specialistList[index].id.toString();
                                return Padding(
                                  padding: const EdgeInsets.only(right: 14, bottom: 4, top: 4),
                                  child: Column(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: selected ? ThemeProvider.appColor : ThemeProvider.borderColor, width: selected ? 2 : 1),
                                            ),
                                            padding: const EdgeInsets.all(3),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(40),
                                              child: SizedBox.fromSize(
                                                size: const Size.fromRadius(38),
                                                child: FadeInImage(
                                                  image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.specialistList[index].cover}'),
                                                  placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                                  },
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -8,
                                            right: -8,
                                            child: GestureDetector(
                                              onTap: () {
                                                value.saveSpecialist(value.specialistList[index].id as int);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.whiteColor),
                                                child: Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: ThemeProvider.appColor, size: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8, bottom: 3),
                                        child: Text(
                                          '${value.specialistList[index].firstName} ${value.specialistList[index].lastName}',
                                          style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary),
                                        ),
                                      ),
                                    ],
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
