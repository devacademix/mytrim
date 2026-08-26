import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/slot_controller.dart';
import 'package:owner/app/util/theme.dart';

class SlotScreen extends StatefulWidget {
  const SlotScreen({super.key});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SlotController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Slots'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _AddNewButton(onTap: () => value.onAddNew()),
              ),
            ],
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.slotList.isEmpty
                  ? const _EmptyState(message: 'No Slots Found!')
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.slotList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _DayCard(index: index, value: value),
                    ),
        );
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.index, required this.value});

  final int index;
  final SlotController value;

  @override
  Widget build(BuildContext context) {
    final item = value.slotList[index];
    final slots = item.slots ?? [];
    return Container(
      decoration: ThemeProvider.cardDecoration(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.event_repeat, size: 16, color: ThemeProvider.appColor),
                  ),
                  const SizedBox(width: 10),
                  Text(value.dayList[item.weekId as int].toString(), style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                ],
              ),
              Row(
                children: [
                  _IconChip(icon: Icons.edit_outlined, color: ThemeProvider.appColor, onTap: () => value.onEdit(item.id as int)),
                  const SizedBox(width: 6),
                  _IconChip(
                    icon: Icons.delete_outline,
                    color: const Color(0xFFDC2626),
                    onTap: () => _showDeleteDialog(context, message: 'to delete Slots ?'.tr, onConfirm: () => value.onSlotDestroy(item.id as int)),
                  ),
                ],
              ),
            ],
          ),
          if (slots.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: ThemeProvider.dividerColor)),
            Wrap(
              spacing: 10,
              runSpacing: 12,
              children: List.generate(
                slots.length,
                (subIndex) => _SlotChip(
                  label: '${slots[subIndex].startTime} to ${slots[subIndex].endTime}',
                  onDelete: () => _showDeleteDialog(context, message: 'to delete Slots ?'.tr, onConfirm: () => value.onDistroy(index, subIndex)),
                ),
              ),
            ),
          ],
        ],
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
            decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), border: Border.all(color: ThemeProvider.dividerColor)),
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

class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.color, required this.onTap});

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _AddNewButton extends StatelessWidget {
  const _AddNewButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ThemeProvider.whiteColor.withOpacity(0.16),
      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), border: Border.all(color: ThemeProvider.whiteColor.withOpacity(0.4))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 16, color: ThemeProvider.whiteColor),
              const SizedBox(width: 4),
              Text('Add New'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 12, color: ThemeProvider.whiteColor)),
            ],
          ),
        ),
      ),
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
          Text(message.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.mutedTextColor)),
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
