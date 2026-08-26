import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/add_timing_controller.dart';
import 'package:owner/app/util/theme.dart';

class AddTimingScreen extends StatefulWidget {
  const AddTimingScreen({super.key});

  @override
  State<AddTimingScreen> createState() => _AddTimingScreenState();
}

class _AddTimingScreenState extends State<AddTimingScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddTimingController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Add Timing'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                decoration: ThemeProvider.cardDecoration(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.event_repeat, size: 16, color: ThemeProvider.appColor),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Day'.tr, style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor)),
                                DropdownButton<String>(
                                  value: value.dayName,
                                  isExpanded: true,
                                  icon: const Icon(Icons.expand_more, color: ThemeProvider.mutedTextColor),
                                  elevation: 16,
                                  style: const TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.blackColor),
                                  underline: const SizedBox(),
                                  onChanged: (String? newValue) => value.onUpdateDayName(newValue.toString()),
                                  items: <String>['Sunday'.tr, 'Monday'.tr, 'Tuesday'.tr, 'Wednesday'.tr, 'Thursday'.tr, 'Friday'.tr, 'Saturday'.tr].map<DropdownMenuItem<String>>((String selected) {
                                    return DropdownMenuItem<String>(value: selected, child: Text(selected));
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: ThemeProvider.dividerColor),
                    _TimeRow(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Open Time'.tr,
                      value: value.openTime == '' ? 'Open Time'.tr : value.openTime.toString(),
                      isPlaceholder: value.openTime == '',
                      onTap: () => value.openTimePicker(),
                    ),
                    const Divider(height: 1, color: ThemeProvider.dividerColor),
                    _TimeRow(
                      icon: Icons.nights_stay_outlined,
                      label: 'Close Time'.tr,
                      value: value.closeTime == '' ? 'Close Time'.tr : value.closeTime.toString(),
                      isPlaceholder: value.closeTime == '',
                      onTap: () => value.closeTimePicker(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ThemeProvider.whiteColor,
                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                      border: Border.all(color: ThemeProvider.dividerColor),
                    ),
                    child: Text('Cancle'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.mutedTextColor)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                    onTap: value.action == 'new' ? () => value.onSaveTime() : () => value.onUpdateTime(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      decoration: contentButtonStyle(),
                      child: Center(
                        child: Text(value.action == 'new' ? 'Save'.tr : 'Update'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.whiteColor, fontSize: 15)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({required this.icon, required this.label, required this.value, required this.isPlaceholder, required this.onTap});

  final IconData icon;
  final String label;
  final String value;
  final bool isPlaceholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 16, color: ThemeProvider.appColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 14, fontFamily: 'medium', color: isPlaceholder ? ThemeProvider.subtleTextColor : ThemeProvider.blackColor)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: ThemeProvider.subtleTextColor),
          ],
        ),
      ),
    );
  }
}

contentButtonStyle() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(100.0)),
    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
}
