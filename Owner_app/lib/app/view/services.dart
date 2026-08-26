import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/backend/models/services_model.dart';
import 'package:owner/app/controller/services_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServicesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Services'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _AddNewButton(onTap: () => value.onAddNew()),
              ),
            ],
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.servicesList.isEmpty
                  ? const _EmptyState(message: 'No Services Found!')
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.servicesList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _ServiceCard(item: value.servicesList[i], value: value),
                    ),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item, required this.value});

  final ServicesModel item;
  final ServicesController value;

  String _money(num? amount) {
    final text = amount.toString();
    return value.currencySide == 'left' ? '${value.currencySymbol}$text' : '$text${value.currencySymbol}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeProvider.cardDecoration(),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(28),
                  child: FadeInImage(
                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 56, width: 56);
                    },
                    fit: BoxFit.cover,
                    width: 56,
                    height: 56,
                  ),
                ),
              ),
              if ((item.discount ?? 0) > 0)
                Positioned(
                  bottom: -6,
                  left: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), boxShadow: ThemeProvider.cardShadow),
                    child: Text('${item.discount!.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 9, fontFamily: 'bold', color: ThemeProvider.whiteColor)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor)),
                const SizedBox(height: 3),
                Text(item.webCatesData!.name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: _money(item.price), style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor, decoration: TextDecoration.lineThrough)),
                          const TextSpan(text: '  '),
                          TextSpan(text: _money(item.off), style: const TextStyle(fontSize: 12, color: ThemeProvider.appColor, fontFamily: 'bold')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.circle, size: 3, color: ThemeProvider.subtleTextColor),
                    const SizedBox(width: 8),
                    const Icon(Icons.schedule, size: 12, color: ThemeProvider.subtleTextColor),
                    const SizedBox(width: 3),
                    Text('${item.duration} min'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              _IconChip(
                icon: item.status == 1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: item.status == 1 ? const Color(0xFF16A34A) : ThemeProvider.mutedTextColor,
                onTap: () => value.updateStatus(item.id as int, item.status as int),
              ),
              const SizedBox(height: 6),
              _IconChip(icon: Icons.edit_outlined, color: ThemeProvider.appColor, onTap: () => value.onEdit(item.id as int)),
              const SizedBox(height: 6),
              _IconChip(
                icon: Icons.delete_outline,
                color: const Color(0xFFDC2626),
                onTap: () => _showDeleteDialog(context, message: 'to delete Slots ?'.tr, onConfirm: () => value.onDestroy(item.id as int)),
              ),
            ],
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
