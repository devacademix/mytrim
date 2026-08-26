import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/packages_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/constance.dart';
import 'package:owner/app/util/theme.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  String _money(num? amount) {
    final text = amount.toString();
    return AppConstants.defaultCurrencySide == 'left' ? '${AppConstants.defaultCurrencySymbol}$text' : '$text${AppConstants.defaultCurrencySymbol}';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Packages'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Material(
                  color: ThemeProvider.whiteColor,
                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                    onTap: () => value.onAddPackages(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, size: 16, color: ThemeProvider.appColor),
                          const SizedBox(width: 4),
                          Text('Add New'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.packagesList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/no-data.png', width: 72, height: 72),
                          const SizedBox(height: 18),
                          Text('No Packages Found!'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.mutedTextColor)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.packagesList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = value.packagesList[index];
                        return Container(
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
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(28),
                                      child: FadeInImage(
                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 56, width: 56);
                                        },
                                        fit: BoxFit.cover,
                                        height: 56,
                                        width: 56,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                    onTap: () => value.updateStatus(item.id as int, item.status as int),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        item.status == 1 ? Icons.visibility : Icons.visibility_off,
                                        size: 18,
                                        color: item.status == 1 ? const Color(0xFF16A34A) : ThemeProvider.subtleTextColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                    onTap: () {
                                      value.onEdit(item.id as int);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Icon(Icons.edit_note, size: 20, color: ThemeProvider.appColor),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.cardRadius)),
                                            contentPadding: const EdgeInsets.all(20),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset('assets/images/delete.png', fit: BoxFit.cover, height: 80, width: 80),
                                                  const SizedBox(height: 20),
                                                  Text('Are you sure'.tr, style: const TextStyle(fontSize: 22, fontFamily: 'semi-bold')),
                                                  const SizedBox(height: 8),
                                                  Text('to delete Slots ?'.tr, style: const TextStyle(color: ThemeProvider.mutedTextColor)),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          style: ElevatedButton.styleFrom(
                                                            foregroundColor: ThemeProvider.backgroundColor,
                                                            backgroundColor: ThemeProvider.redColor,
                                                            minimumSize: const Size.fromHeight(42),
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                          ),
                                                          child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 15)),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 14),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            value.onDestroy(item.id as int);
                                                            Navigator.pop(context);
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            foregroundColor: ThemeProvider.backgroundColor,
                                                            backgroundColor: ThemeProvider.greenColor,
                                                            minimumSize: const Size.fromHeight(42),
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                          ),
                                                          child: Text(
                                                            'Delete'.tr,
                                                            style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Icon(Icons.delete_outline, size: 20, color: ThemeProvider.redColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1, color: ThemeProvider.dividerColor)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if ((item.services ?? []).isNotEmpty)
                                    Expanded(
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: List.generate(
                                          item.services!.length,
                                          (subIndex) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                            child: Text(
                                              item.services![subIndex].name.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 11, color: ThemeProvider.mutedTextColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    const Spacer(),
                                  if (value.userType == true && (item.specialist ?? []).isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        height: 26,
                                        width: 22.0 + (item.specialist!.take(4).length - 1) * 14.0,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.centerRight,
                                          children: List.generate(
                                            item.specialist!.take(4).length,
                                            (specialistIndex) => Positioned(
                                              right: 14.0 * specialistIndex,
                                              child: SizedBox(
                                                height: 26,
                                                width: 26,
                                                child: Container(
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: ThemeProvider.whiteColor, width: 1.5)),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: SizedBox.fromSize(
                                                      size: const Size.fromRadius(40),
                                                      child: FadeInImage(
                                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.specialist![specialistIndex].cover}'),
                                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                        imageErrorBuilder: (context, error, stackTrace) {
                                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 40, width: 40);
                                                        },
                                                        fit: BoxFit.cover,
                                                        height: 40,
                                                        width: 40,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: _money(item.price), style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor, decoration: TextDecoration.lineThrough)),
                                    const TextSpan(text: '  '),
                                    TextSpan(text: _money(item.off), style: const TextStyle(fontSize: 13, color: ThemeProvider.appColor, fontFamily: 'bold')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
