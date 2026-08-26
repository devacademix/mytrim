import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/individual_profile_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class IndividualProfileScreen extends StatefulWidget {
  const IndividualProfileScreen({super.key});

  @override
  State<IndividualProfileScreen> createState() => _IndividualProfileScreenState();
}

class _IndividualProfileScreenState extends State<IndividualProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualProfileController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 230,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28))),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  FadeInImage(
                                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.backgroundCover}'),
                                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 230, width: double.infinity);
                                    },
                                    fit: BoxFit.cover,
                                    height: 230,
                                    width: double.infinity,
                                  ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [ThemeProvider.blackColor.withOpacity(0.35), ThemeProvider.blackColor.withOpacity(0.05)],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12, right: 8, left: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => Get.back(),
                                    icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(color: ThemeProvider.appColor, shape: BoxShape.circle, boxShadow: ThemeProvider.cardShadow),
                                    child: IconButton(
                                      onPressed: () {
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
                                      icon: const Icon(Icons.edit, size: 18, color: ThemeProvider.whiteColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 14),
                              child: _SectionCaption(),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldCard(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => value.onSelectCategories(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                                    decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(12)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: value.individualInfo.webCatesData!.isEmpty
                                              ? Text('Select Category'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.subtleTextColor))
                                              : Wrap(
                                                  spacing: 6,
                                                  runSpacing: 6,
                                                  children: List.generate(
                                                    value.individualInfo.webCatesData!.length,
                                                    (index) => Text(
                                                      value.individualInfo.webCatesData![index].name.toString(),
                                                      style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.blackColor),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        const Icon(Icons.chevron_right, color: ThemeProvider.mutedTextColor),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _StyledField(controller: value.aboutTextEditor, hint: 'Brief Of Salon'.tr, maxLines: 3),
                                const SizedBox(height: 12),
                                _StyledField(controller: value.addressTextEditor, hint: 'Enter Address..'.tr, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _FieldCard(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => value.onSelectCities(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                                    decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(12)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          value.individualInfo.cityData!.name.toString() == '' || value.individualInfo.cityData!.name!.isEmpty ? 'Select'.tr : value.individualInfo.cityData!.name.toString(),
                                          style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.blackColor),
                                        ),
                                        const Icon(Icons.expand_more, color: ThemeProvider.mutedTextColor),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _StyledField(controller: value.zipCodeTextEditor, hint: 'ZIP Code'.tr),
                                const SizedBox(height: 12),
                                _StyledField(controller: value.latTextEditor, hint: 'Latitude'.tr),
                                const SizedBox(height: 12),
                                _StyledField(controller: value.lngTextEditor, hint: 'Longitude'.tr),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _FieldCard(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              children: [
                                _ToggleRow(label: 'Have Popular ?'.tr, value: value.havePopular, onChanged: (bool status) => value.updatePopular(status)),
                                const Divider(height: 1, color: ThemeProvider.dividerColor),
                                _ToggleRow(label: 'Have Shop ?'.tr, value: value.haveShop, onChanged: (bool status) => value.updateShop(status)),
                                const Divider(height: 1, color: ThemeProvider.dividerColor),
                                _ToggleRow(label: 'Have Home ?'.tr, value: value.haveHome, onChanged: (bool status) => value.updateHome(status)),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Opening Hour'.tr, style: const TextStyle(fontSize: 15, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                                InkWell(
                                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                  onTap: () => value.onAddNewTiming(),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(Icons.add_circle, color: ThemeProvider.appColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _FieldCard(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              children: List.generate(
                                value.timesList.length,
                                (index) => Column(
                                  children: [
                                    if (index != 0) const Divider(height: 1, color: ThemeProvider.dividerColor),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                            child: Text(
                                              value.getDayName(value.timesList[index].day as int),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'medium', fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '${value.timesList[index].openTime} - ${value.timesList[index].closeTime}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'medium', fontSize: 13),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                            onTap: () {
                                              value.onEditTime(value.getDayName(value.timesList[index].day as int), value.timesList[index].openTime.toString(), value.timesList[index].closeTime.toString());
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(color: ThemeProvider.orangeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                              child: Text('Edit'.tr, style: const TextStyle(fontSize: 11, fontFamily: 'bold', color: ThemeProvider.orangeColor)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => value.updateIndividual(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                decoration: contentButtonStyle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SUBMIT'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold', letterSpacing: 0.5)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionCaption extends StatelessWidget {
  const _SectionCaption();

  @override
  Widget build(BuildContext context) {
    return Text('Business Profile'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 16, color: ThemeProvider.whiteColor));
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({required this.children, this.padding = const EdgeInsets.all(14)});

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: ThemeProvider.cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _StyledField extends StatelessWidget {
  const _StyledField({required this.controller, required this.hint, this.maxLines = 1});

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: ThemeProvider.surfaceTint,
        hintText: hint,
        hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ThemeProvider.appColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor)),
          Switch(value: value, onChanged: onChanged, activeColor: ThemeProvider.appColor),
        ],
      ),
    );
  }
}

BoxDecoration contentButtonStyle() {
  return BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(100.0)),
    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
    boxShadow: [BoxShadow(color: ThemeProvider.appColor.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
  );
}
