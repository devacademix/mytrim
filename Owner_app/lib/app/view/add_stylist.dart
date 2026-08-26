import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/add_stylist_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class AddStylistScreen extends StatefulWidget {
  const AddStylistScreen({super.key});

  @override
  State<AddStylistScreen> createState() => _AddStylistScreenState();
}

class _AddStylistScreenState extends State<AddStylistScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddStylistController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Add Stylist'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
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
                                decoration: BoxDecoration(color: ThemeProvider.whiteColor, shape: BoxShape.circle, boxShadow: ThemeProvider.cardShadow),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(56),
                                    child: FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
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
                      ],
                    ),
                  ),
                  _FormField(controller: value.firstNameTextEditor, hint: 'First Name'.tr),
                  const SizedBox(height: 12),
                  _FormField(controller: value.lastNameTextEditor, hint: 'Last Name'.tr),
                  const SizedBox(height: 12),
                  _SelectorField(
                    label: 'Categories'.tr,
                    value: value.savedCategories.isEmpty ? 'Select Categories'.tr : value.savedCategories.join(', '),
                    isPlaceholder: value.savedCategories.isEmpty,
                    onTap: () => value.onSelectStylist(),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
              onTap: value.action == 'new' ? () => value.saveSpecilaist() : () => value.onUpdateSpecialist(),
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
      },
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.blackColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: ThemeProvider.whiteColor,
          hintText: hint,
          hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
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
      decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.dividerColor)),
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
