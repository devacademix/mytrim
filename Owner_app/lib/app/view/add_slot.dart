import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/add_slot_controller.dart';
import 'package:owner/app/util/theme.dart';

class AddSlotScreen extends StatefulWidget {
  const AddSlotScreen({super.key});

  @override
  State<AddSlotScreen> createState() => _AddSlotScreenState();
}

class _AddSlotScreenState extends State<AddSlotScreen> {
  static const List<String> _days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSlotController>(
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
            title: Text('Add Slots'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: ThemeProvider.cardDecoration(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
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
                      if (value.slotList.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Added Slots'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 13, color: ThemeProvider.blackColor)),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            value.slotList.length,
                            (index) => _SlotChip(
                              label: '${value.slotList[index].startTime} to ${value.slotList[index].endTime}',
                              onDelete: () => _showDeleteDialog(context, message: 'to delete this slot ?'.tr, onConfirm: () => value.onDestroy(index)),
                            ),
                          ),
                        ),
                      ],
                    ],
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
                    child: OutlinedButton(
                      onPressed: () => value.addSlots(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ThemeProvider.appColor,
                        side: const BorderSide(color: ThemeProvider.appColor, width: 1.4),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Add'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (value.action == 'create') {
                          value.saveSlots();
                        } else {
                          value.updateSlots();
                        }
                      },
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: contentButtonStyle(),
                        child: Text('Save & Submit'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.whiteColor, fontSize: 14)),
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

class _SlotChip extends StatelessWidget {
  const _SlotChip({required this.label, required this.onDelete});

  final String label;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 6),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), border: Border.all(color: ThemeProvider.dividerColor)),
            child: Text(label, style: const TextStyle(fontFamily: 'medium', fontSize: 12, color: ThemeProvider.blackColor)),
          ),
          Positioned(
            right: -8,
            top: -8,
            child: InkWell(
              onTap: onDelete,
              child: Container(
                height: 18,
                width: 18,
                decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
                child: const Icon(Icons.close, color: ThemeProvider.whiteColor, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context, {required String message, required VoidCallback onConfirm}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFDC2626).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 32),
              ),
              const SizedBox(height: 16),
              Text('Are you sure'.tr, style: const TextStyle(fontSize: 17, fontFamily: 'bold', color: ThemeProvider.blackColor)),
              const SizedBox(height: 6),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ThemeProvider.mutedTextColor,
                        side: const BorderSide(color: ThemeProvider.dividerColor),
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                      ),
                      child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ThemeProvider.whiteColor,
                        backgroundColor: const Color(0xFFDC2626),
                        elevation: 0,
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                      ),
                      child: Text('Delete'.tr, style: const TextStyle(fontFamily: 'bold')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

contentButtonStyle() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
}
