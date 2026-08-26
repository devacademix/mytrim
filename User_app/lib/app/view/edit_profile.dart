import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:user/app/controller/edit_profile_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/env.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.textSecondary),
      border: InputBorder.none,
      isDense: true,
    );
  }

  BoxDecoration get _fieldBox => BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.borderColor, width: 1));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text('Edit Profile'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
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
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: ThemeProvider.borderColor, width: 1)),
                              width: 96,
                              height: 96,
                              child: value.cover.toString().isNotEmpty
                                  ? FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover.toString()}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/placeholder.jpeg', fit: BoxFit.cover, height: 96, width: 96);
                                      },
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/placeholder.jpeg',
                                      fit: BoxFit.cover,
                                      height: 96,
                                      width: 96,
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(color: ThemeProvider.appColor, shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: ThemeProvider.whiteColor, width: 2))),
                                child: const Icon(Icons.camera_alt_outlined, color: ThemeProvider.whiteColor, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: _fieldBox,
                              child: TextFormField(
                                controller: value.firstNameTextEditor,
                                onChanged: (String txt) {},
                                cursorColor: ThemeProvider.appColor,
                                style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                                decoration: _fieldDecoration('First Name'.tr),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: _fieldBox,
                              child: TextFormField(
                                controller: value.lastNameTextEditor,
                                onChanged: (String txt) {},
                                cursorColor: ThemeProvider.appColor,
                                style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                                decoration: _fieldDecoration('Last Name'.tr),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) => CupertinoActionSheet(
                              title: Text('Gender'.tr),
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    value.updateGender(1);
                                  },
                                  child: Text('Male'.tr),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    value.updateGender(0);
                                  },
                                  child: Text('Female'.tr),
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
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: _fieldBox,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gender'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'regular', color: ThemeProvider.textSecondary)),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(value.selectedGender == 0 ? 'Female'.tr : 'Male'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary)),
                                  const Icon(Icons.keyboard_arrow_down, color: ThemeProvider.textSecondary)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: _fieldBox,
                        child: TextFormField(
                          readOnly: true,
                          controller: value.emailTextEditor,
                          onChanged: (String txt) {},
                          cursorColor: ThemeProvider.appColor,
                          style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                          decoration: _fieldDecoration('Email'.tr),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            constraints: const BoxConstraints(minWidth: 110),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: _fieldBox,
                            child: CountryCodePicker(
                              onChanged: (e) => value.saveCountryCode(e.dialCode.toString()),
                              initialSelection: value.countryCodeMobile.toString().isNotEmpty ? value.countryCodeMobile.toString() : 'IN',
                              favorite: const ['+91', 'IN'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              textStyle: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14, fontFamily: 'medium'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: _fieldBox,
                              child: TextFormField(
                                controller: value.mobileTextEditor,
                                onChanged: (String txt) {},
                                cursorColor: ThemeProvider.appColor,
                                style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                                decoration: _fieldDecoration('Phone'.tr),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => value.onUpdateInfo(),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeProvider.appColor,
                              foregroundColor: ThemeProvider.whiteColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                              padding: const EdgeInsets.all(0)),
                          child: Text(
                            'Submit'.tr,
                            style: const TextStyle(letterSpacing: 0.3, fontSize: 16, color: ThemeProvider.whiteColor, fontFamily: 'semibold'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }
}
