import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/add_packages_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class AddPackagesScreen extends StatefulWidget {
  const AddPackagesScreen({super.key});

  @override
  State<AddPackagesScreen> createState() => _AddPackagesScreenState();
}

InputDecoration _fieldDecoration(String hint) {
  return InputDecoration(
    filled: true,
    fillColor: ThemeProvider.surfaceTint,
    hintText: hint,
    hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.5)),
  );
}

BoxDecoration _pickerDecoration() {
  return BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.dividerColor));
}

class _AddPackagesScreenState extends State<AddPackagesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddPackagesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Add Packages'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
              child: Column(
                children: [
                  Row(
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
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ThemeProvider.dividerColor, width: 1), boxShadow: ThemeProvider.cardShadow),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(70),
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
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor),
                                child: const Icon(Icons.camera_alt, size: 14, color: ThemeProvider.whiteColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      decoration: _pickerDecoration(),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => value.onSelectPackages(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: value.savedCategories.isEmpty
                                    ? Text('Select Categories'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.subtleTextColor))
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: List.generate(
                                          value.savedCategories.length,
                                          (name) => Padding(
                                            padding: const EdgeInsets.only(bottom: 2),
                                            child: Text(value.savedCategories[name].toString(), style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor)),
                                          ),
                                        ),
                                      ),
                              ),
                              const Icon(Icons.chevron_right, color: ThemeProvider.subtleTextColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  value.userType == true
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Container(
                            decoration: _pickerDecoration(),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => value.onSelectSpecialist(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: value.savedSpecialist.isEmpty
                                          ? Text('Select Specialist'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.subtleTextColor))
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: List.generate(
                                                value.savedSpecialist.length,
                                                (firstName) => Padding(
                                                  padding: const EdgeInsets.only(bottom: 2),
                                                  child: Text(value.savedSpecialist[firstName].toString(), style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor)),
                                                ),
                                              ),
                                            ),
                                    ),
                                    const Icon(Icons.chevron_right, color: ThemeProvider.subtleTextColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: value.packagesNameTextEditor,
                        style: const TextStyle(fontSize: 14),
                        decoration: _fieldDecoration('Packages Name'.tr),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: value.priceTextEditor,
                        onChanged: (String txt) => value.onRealPrice(txt),
                        style: const TextStyle(fontSize: 14),
                        decoration: _fieldDecoration('Price'.tr),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: value.discountTextEditor,
                        onChanged: (String txt) => value.onDiscountPrice(txt),
                        style: const TextStyle(fontSize: 14),
                        decoration: _fieldDecoration('Discount'.tr),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: value.sellPriceTextEditor,
                        style: const TextStyle(fontSize: 14),
                        decoration: _fieldDecoration('Sell Price'.tr),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: value.descriptionTextEditor,
                        maxLines: 5,
                        style: const TextStyle(fontSize: 14),
                        decoration: _fieldDecoration('Descriptions'.tr),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: value.durationTextEditor,
                        style: const TextStyle(fontSize: 14),
                        decoration: _fieldDecoration('Duration'.tr),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: Row(children: [Text('Upload More Image'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor))]),
                  ),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: ThemeProvider.dividerColor)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: FadeInImage(
                                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.gallery[index]}'),
                                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                    },
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: value.action == 'new'
                  ? InkWell(
                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                      onTap: () => value.onSave(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        decoration: contentButtonStyle(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('ADD PACKAGES'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 15))],
                        ),
                      ),
                    )
                  : InkWell(
                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                      onTap: () => value.onUpdate(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(ThemeProvider.chipRadius)), color: ThemeProvider.greenColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('UPDATE PACKAGES'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 15))],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

contentButtonStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
}

class FruitsList {
  String name;
  int index;
  FruitsList({required this.name, required this.index});
}
