import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/add_services_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class AddServicesScreen extends StatefulWidget {
  const AddServicesScreen({super.key});

  @override
  State<AddServicesScreen> createState() => _AddServicesScreenState();
}

class _AddServicesScreenState extends State<AddServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddServicesController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.surfaceTint,
        appBar: AppBar(
          backgroundColor: ThemeProvider.appColor,
          iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 50,
          title: Text('Add Service'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
        ),
        body: value.apiCalled == false
            ? SkeletonListView()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) => CupertinoActionSheet(
                                title: Text('Choose From'.tr),
                                actions: <CupertinoActionSheetAction>[
                                  CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      value.selectFromGallery('camera');
                                    },
                                    child: Text('Camera'.tr),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      value.selectFromGallery('gallery');
                                    },
                                    child: Text('Gallery'.tr),
                                  ),
                                  CupertinoActionSheetAction(
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'.tr),
                                  )
                                ],
                              ),
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(16), boxShadow: ThemeProvider.cardShadow),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(60),
                                    child: FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 60, width: 60);
                                      },
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -2,
                                bottom: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: ThemeProvider.appColor, shape: BoxShape.circle, border: Border.all(color: ThemeProvider.whiteColor, width: 2)),
                                  child: const Icon(Icons.camera_alt, size: 13, color: ThemeProvider.whiteColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        children: [
                          _FormField(controller: value.nameTextEditor, hint: 'Service Name'.tr),
                          const SizedBox(height: 12),
                          _SelectorField(
                            label: 'Categories'.tr,
                            value: value.selectedServicesName == '' ? 'Select Categories'.tr : value.selectedServicesName,
                            isPlaceholder: value.selectedServicesName == '',
                            onTap: () => value.onServiceCategories(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _FormField(controller: value.priceTextEditor, hint: 'Service Price'.tr, onChanged: (txt) => value.onRealPrice(txt))),
                              const SizedBox(width: 12),
                              Expanded(child: _FormField(controller: value.discountTextEditor, hint: 'Discount %'.tr, onChanged: (txt) => value.onDiscountPrice(txt))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _FormField(controller: value.offTextEditor, hint: 'Sell Price'.tr, enabled: false),
                          const SizedBox(height: 12),
                          _FormField(controller: value.durationTextEditor, hint: 'Service Duration'.tr, keyboardType: TextInputType.number),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        children: [
                          _FormField(controller: value.descriptionsTextEditor, hint: 'Description'.tr, maxLines: 5),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        children: [
                          _SelectorField(
                            label: 'Status'.tr,
                            value: value.selectedStatus == 1 ? 'Available'.tr : 'Hide'.tr,
                            isPlaceholder: false,
                            onTap: () {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) => CupertinoActionSheet(
                                  title: Text(
                                    'Choose From'.tr,
                                    style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.blackColor, fontSize: 14),
                                  ),
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      child: Text('Available'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 15)),
                                      onPressed: () {
                                        value.updateStatus(1);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text('Hide'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 15)),
                                      onPressed: () {
                                        value.updateStatus(0);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.redColor, fontSize: 14)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Upload More Image'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 13, color: ThemeProvider.blackColor)),
                      ),
                      const SizedBox(height: 10),
                      GridView.count(
                        primary: false,
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        shrinkWrap: true,
                        childAspectRatio: 100 / 100,
                        padding: EdgeInsets.zero,
                        children: List.generate(
                          value.gallery.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoActionSheet(
                                    title: Text('Choose From'.tr),
                                    actions: <CupertinoActionSheetAction>[
                                      CupertinoActionSheetAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                          value.selectFromGalleryOthers('camera', index);
                                        },
                                        child: Text('Camera'.tr),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          value.selectFromGalleryOthers('gallery', index);
                                        },
                                        child: Text('Gallery'.tr),
                                      ),
                                      CupertinoActionSheetAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'.tr),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: ThemeProvider.dividerColor)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: FadeInImage(
                                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.gallery[index].toString()}'),
                                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
            onTap: value.action == 'new' ? () => value.onSubmit() : () => value.onUpdateService(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              decoration: contentButtonStyle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(value.action == 'new' ? 'SUBMIT'.tr : 'UPDATE'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 15))],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ThemeProvider.cardDecoration(),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.controller, required this.hint, this.onChanged, this.enabled = true, this.keyboardType, this.maxLines = 1});

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.blackColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? ThemeProvider.surfaceTint : ThemeProvider.dividerColor.withOpacity(0.5),
          hintText: hint,
          hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
        ),
      ),
    );
  }
}

class _SelectorField extends StatelessWidget {
  const _SelectorField({required this.label, required this.value, required this.isPlaceholder, required this.onTap});

  final String label;
  final String value;
  final bool isPlaceholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor)),
                    const SizedBox(height: 3),
                    Text(value, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontFamily: 'medium', color: isPlaceholder ? ThemeProvider.subtleTextColor : ThemeProvider.blackColor)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: ThemeProvider.subtleTextColor),
            ],
          ),
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
