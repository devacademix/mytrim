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
  static const List<String> _days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddTimingController>(
      builder: (value) {
        final String selectedDay = _days.contains(value.dayName) ? value.dayName : _days.first;

        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Add Timing'.tr, style: ThemeProvider.titleStyle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: ThemeProvider.cardDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.event_repeat, size: 20, color: ThemeProvider.appColor),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Day'.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.subtleTextColor)),
                              const SizedBox(height: 2),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedDay,
                                  isExpanded: true,
                                  icon: const Icon(Icons.expand_more, color: ThemeProvider.mutedTextColor),
                                  style: const TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.blackColor),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) value.onUpdateDayName(newValue);
                                  },
                                  items: _days.map<DropdownMenuItem<String>>((String day) {
                                    return DropdownMenuItem<String>(
                                      value: day,
                                      child: Text(day.tr),
                                    );
                                  }).toList(),
                                ),
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
                    value: value.openTime.isEmpty ? 'Open Time'.tr : value.openTime,
                    isPlaceholder: value.openTime.isEmpty,
                    onTap: () => value.openTimePicker(),
                  ),
                  const Divider(height: 1, color: ThemeProvider.dividerColor),
                  _TimeRow(
                    icon: Icons.nights_stay_outlined,
                    label: 'Close Time'.tr,
                    value: value.closeTime.isEmpty ? 'Close Time'.tr : value.closeTime,
                    isPlaceholder: value.closeTime.isEmpty,
                    onTap: () => value.closeTimePicker(),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeProvider.whiteColor,
              boxShadow: ThemeProvider.cardShadow,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => value.onBack(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ThemeProvider.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ThemeProvider.dividerColor),
                        ),
                        child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.mutedTextColor, fontSize: 14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: value.action == 'new' ? () => value.onSaveTime() : () => value.onUpdateTime(),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: contentButtonStyle(),
                        child: Text(value.action == 'new' ? 'Save'.tr : 'Update'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.whiteColor, fontSize: 15)),
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
              child: Icon(icon, size: 20, color: ThemeProvider.appColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: ThemeProvider.subtleTextColor)),
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
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
}
