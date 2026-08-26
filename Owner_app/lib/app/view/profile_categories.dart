import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/profile_categories_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class ProfileCategoriesScreen extends StatefulWidget {
  const ProfileCategoriesScreen({super.key});

  @override
  State<ProfileCategoriesScreen> createState() => _ProfileCategoriesState();
}

class _ProfileCategoriesState extends State<ProfileCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        margin: const EdgeInsets.only(bottom: 50),
                        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/h4.jpg'), fit: BoxFit.cover)),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 70),
                                child: Row(children: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor))]),
                              ),
                            ),
                            Positioned(
                              bottom: -40,
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
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: ThemeProvider.appColor, width: 3), borderRadius: BorderRadius.circular(100)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(40),
                                      child: FadeInImage(
                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Container(
                                width: double.infinity,
                                decoration: ThemeProvider.cardDecoration(radius: 14),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => value.onSelectCategories(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                          child: const Icon(Icons.category_outlined, size: 18, color: ThemeProvider.appColor),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: List.generate(
                                              (value.profileInfo.webCatesData ?? []).length,
                                              (index) => Padding(
                                                padding: const EdgeInsets.only(bottom: 2),
                                                child: Text(
                                                  value.profileInfo.webCatesData?[index].name.toString() ?? '',
                                                  style: const TextStyle(fontFamily: 'medium', fontSize: 15, color: ThemeProvider.blackColor),
                                                ),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.salonNameTextEditor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    isDense: true,
                                    hintText: 'Enter Salon Name'.tr,
                                    hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 13),
                                    contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.aboutTextEditor,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    isDense: true,
                                    hintText: 'Brief Of Salon'.tr,
                                    hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 13),
                                    contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.addressTextEditor,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    isDense: true,
                                    hintText: 'Enter Address..'.tr,
                                    hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 13),
                                    contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Container(
                                decoration: ThemeProvider.cardDecoration(radius: 14),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => value.onSelectCities(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                              child: const Icon(Icons.location_city_outlined, size: 18, color: ThemeProvider.appColor),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                               value.profileInfo.cityData?.name == null || value.profileInfo.cityData!.name.toString() == '' || value.profileInfo.cityData!.name!.isEmpty
                                                   ? 'Select'.tr
                                                   : value.profileInfo.cityData!.name.toString(),
                                              style: const TextStyle(fontFamily: 'medium', fontSize: 15, color: ThemeProvider.blackColor),
                                            ),
                                          ],
                                        ),
                                        const Icon(Icons.expand_more, color: ThemeProvider.subtleTextColor),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.zipCodeTextEditor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    isDense: true,
                                    hintText: 'ZIP Code'.tr,
                                    hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 13),
                                    contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.latTextEditor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    isDense: true,
                                    hintText: 'Latitude'.tr,
                                    hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 13),
                                    contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.lngTextEditor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    isDense: true,
                                    hintText: 'Longitude'.tr,
                                    hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 13),
                                    contentPadding: const EdgeInsets.only(bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              decoration: ThemeProvider.cardDecoration(radius: 14),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Have Multiple Stylist ?'.tr, style: const TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.blackColor)),
                                        Switch(
                                          value: value.haveStylist,
                                          onChanged: (bool status) => value.updateStylist(status),
                                          activeColor: ThemeProvider.greenColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1, color: ThemeProvider.dividerColor),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Have Shop ?'.tr, style: const TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.blackColor)),
                                        Switch(
                                          value: value.haveShop,
                                          onChanged: (bool status) => value.updateShop(status),
                                          activeColor: ThemeProvider.greenColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text('Have Home ?'.tr, style: const TextStyle(fontSize: 14)),
                            //       Switch(
                            //         value: value.haveHome,
                            //         onChanged: (bool status) => value.updateHome(status),
                            //         activeColor: ThemeProvider.greenColor,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Opening Hour'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                                  InkWell(
                                    onTap: () => value.onAddNewTiming(),
                                    child: const Icon(Icons.add_circle, color: ThemeProvider.appColor),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: List.generate(
                                value.timesList.length,
                                (index) => Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: ThemeProvider.cardDecoration(radius: 14),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(color: ThemeProvider.greenColor.withOpacity(0.12), borderRadius: BorderRadius.circular(9)),
                                        child: const Icon(Icons.schedule, color: ThemeProvider.greenColor, size: 15),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 90,
                                              child: Text(
                                                value.getDayName(value.timesList[index].day as int),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'medium', fontSize: 13),
                                              ),
                                            ),
                                            Text(
                                              '${value.timesList[index].openTime} - ${value.timesList[index].closeTime}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 13),
                                            ),
                                            SizedBox(
                                              height: 26.0,
                                              width: 60,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: ThemeProvider.orangeColor,
                                                  elevation: 0,
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                ),
                                                onPressed: () {
                                                  value.onEditTime(value.getDayName(value.timesList[index].day as int), value.timesList[index].openTime.toString(), value.timesList[index].closeTime.toString());
                                                },
                                                child: Text('Edit'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold')),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: InkWell(
              onTap: () => value.updateSalon(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                decoration: contentButtonStyle().copyWith(boxShadow: ThemeProvider.cardShadow),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('SUBMIT'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 17))],
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
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(100.0)),
    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
}
