import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/backend/models/city_model.dart';
import 'package:owner/app/controller/signup_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';
import 'package:country_picker/country_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  DateTime date = DateTime(2022, 12, 24);
  String genderValue = 'Male';
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Send Register Request'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: value.currentView == 1
                ? InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => value.onNext(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: contentButtonStyle(),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Next'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold', letterSpacing: 0.5))]),
                    ),
                  )
                : value.currentView == 2
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => value.onBack(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ThemeProvider.dividerColor)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text('Previews'.tr, style: const TextStyle(letterSpacing: 0.3, fontSize: 15, color: ThemeProvider.mutedTextColor, fontFamily: 'bold'))],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => value.onRegister(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                decoration: contentButtonStyle(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text('Submit'.tr, style: const TextStyle(letterSpacing: 0.3, fontSize: 15, color: ThemeProvider.whiteColor, fontFamily: 'bold'))],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
          ),
          body: SingleChildScrollView(
            child: value.currentView == 1
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 28),
                          Text('Select your type'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 18, color: ThemeProvider.blackColor)),
                          const SizedBox(height: 6),
                          Text('Choose the option that fits you best'.tr, style: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor)),
                          const SizedBox(height: 36),
                          _TypeOption(
                            selected: value.type == 1,
                            label: 'Salon'.tr,
                            image: 'assets/images/salon.png',
                            onTap: () => value.updateType(1),
                          ),
                          const SizedBox(height: 16),
                          _TypeOption(
                            selected: value.type == 0,
                            label: 'Individual'.tr,
                            image: 'assets/images/freelancer.png',
                            onTap: () => value.updateType(0),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: myBoxDecoration(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 22),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showCupertinoModalPopup<void>(
                                                  context: context,
                                                  builder: (BuildContext context) => CupertinoActionSheet(
                                                    title: Text('Choose From'.tr),
                                                    actions: <CupertinoActionSheetAction>[
                                                      CupertinoActionSheetAction(
                                                        child: Text('Gallery'.tr),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          value.selectFromGallery('gallery');
                                                        },
                                                      ),
                                                      CupertinoActionSheetAction(
                                                        child: Text('Camera'.tr),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          value.selectFromGallery('camera');
                                                        },
                                                      ),
                                                      CupertinoActionSheetAction(
                                                        child: Text(
                                                          'Cancel'.tr,
                                                          style: const TextStyle(fontFamily: 'bold', color: Colors.red),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(3),
                                                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ThemeProvider.dividerColor, width: 1)),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child: FadeInImage(
                                                        height: 92,
                                                        width: 92,
                                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                        imageErrorBuilder: (context, error, stackTrace) {
                                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 92, width: 92);
                                                        },
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: -2,
                                                    right: -2,
                                                    child: Container(
                                                      padding: const EdgeInsets.all(6),
                                                      decoration: const BoxDecoration(color: ThemeProvider.appColor, shape: BoxShape.circle),
                                                      child: const Icon(Icons.camera_alt, size: 14, color: ThemeProvider.whiteColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: TextFormField(
                                        controller: value.emailTextEditor,
                                        readOnly: value.emailVerified,
                                        onChanged: (String txt) {},
                                        cursorColor: ThemeProvider.appColor,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                          border: InputBorder.none,
                                          labelText: "Email".tr,
                                          suffix: GestureDetector(
                                            onTap: () => value.verifyEmail(),
                                            child: Text(
                                              value.emailVerified == false ? 'Verify'.tr : 'Verified'.tr,
                                              style: TextStyle(color: value.emailVerified == true ? const Color(0xFF16A34A) : ThemeProvider.appColor, fontSize: 12, fontFamily: 'medium'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                          decoration: textFieldDecoration(),
                                          width: 64,
                                          child: GestureDetector(
                                            onTap: () {
                                              showCountryPicker(
                                                context: context,
                                                favorite: <String>['IN'],
                                                showPhoneCode: true,
                                                onSelect: (Country country) {
                                                  if (value.phoneVerified == false) {
                                                    value.saveCountryCode(country.phoneCode.toString());
                                                    debugPrint(country.phoneCode);
                                                  }
                                                },
                                                countryListTheme: CountryListThemeData(
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
                                                  inputDecoration: InputDecoration(
                                                    labelText: 'Search'.tr,
                                                    hintText: 'Start typing to search'.tr,
                                                    prefixIcon: const Icon(Icons.search),
                                                    border: OutlineInputBorder(borderSide: BorderSide(color: const Color(0xFF8C98A8).withOpacity(0.2))),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [smallText('Code'.tr), const SizedBox(height: 4), bodyText1(value.countryCodeMobile.toString())],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            decoration: textFieldDecoration(),
                                            child: TextFormField(
                                              controller: value.mobileTextEditor,
                                              onChanged: (String txt) {},
                                              readOnly: value.phoneVerified,
                                              cursorColor: ThemeProvider.appColor,
                                              style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                              decoration: InputDecoration(
                                                labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                                border: InputBorder.none,
                                                labelText: "Phone".tr,
                                                suffix: GestureDetector(
                                                    onTap: () => value.verifyPhone(),
                                                    child: Text(
                                                      value.phoneVerified == false ? 'Verify'.tr : 'Verified'.tr,
                                                      style: TextStyle(color: value.phoneVerified == true ? const Color(0xFF16A34A) : ThemeProvider.appColor, fontSize: 12, fontFamily: 'medium'),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  value.type == 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            decoration: textFieldDecoration(),
                                            child: TextFormField(
                                              controller: value.name,
                                              onChanged: (String txt) {},
                                              cursorColor: ThemeProvider.appColor,
                                              style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                              decoration: InputDecoration(
                                                labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                                border: InputBorder.none,
                                                labelText: "Salon Name".tr,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            decoration: textFieldDecoration(),
                                            child: TextFormField(
                                              controller: value.firstNameTextEditor,
                                              onChanged: (String txt) {},
                                              cursorColor: ThemeProvider.appColor,
                                              style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                              decoration: InputDecoration(
                                                labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                                border: InputBorder.none,
                                                labelText: "First Name".tr,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            decoration: textFieldDecoration(),
                                            child: TextFormField(
                                              controller: value.lastNameTextEditor,
                                              onChanged: (String txt) {},
                                              cursorColor: ThemeProvider.appColor,
                                              style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                              decoration: InputDecoration(
                                                labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                                border: InputBorder.none,
                                                labelText: "Last Name".tr,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: TextFormField(
                                        controller: value.passwordTextEditor,
                                        onChanged: (String txt) {},
                                        cursorColor: ThemeProvider.appColor,
                                        obscureText: value.passwordVisible,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                          suffixIcon: IconButton(
                                            onPressed: () => value.togglePasswordBtn(),
                                            icon: Icon(value.passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.mutedTextColor, size: 20),
                                          ),
                                          border: InputBorder.none,
                                          labelText: "Password".tr,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: TextFormField(
                                        controller: value.confirmPasswordTextEditor,
                                        onChanged: (String txt) {},
                                        cursorColor: ThemeProvider.appColor,
                                        obscureText: value.passwordVisible,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                          suffixIcon: IconButton(
                                            onPressed: () => value.togglePasswordBtn(),
                                            icon: Icon(
                                              value.passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                              color: ThemeProvider.mutedTextColor,
                                              size: 20,
                                            ),
                                          ),
                                          border: InputBorder.none,
                                          labelText: "Confirm Password".tr,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: DropdownButton<String>(
                                          value: value.selectedGender,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor, fontFamily: 'regular'),
                                          icon: const Icon(Icons.keyboard_arrow_down, color: ThemeProvider.mutedTextColor),
                                          onChanged: (String? newValue) => value.saveGender(newValue.toString()),
                                          items: value.genderList.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(value: value, child: Text(value));
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: TextFormField(
                                        controller: value.feeStart,
                                        cursorColor: ThemeProvider.appColor,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                          border: InputBorder.none,
                                          labelText: "Fee Started Price".tr,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: TextFormField(
                                        controller: value.descriptionsTextEditor,
                                        onChanged: (String txt) {},
                                        cursorColor: ThemeProvider.appColor,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 4,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                          border: InputBorder.none,
                                          labelText: "Description".tr,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => value.onCategoriesList(),
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              smallText('Select Category'.tr),
                                              const Icon(Icons.chevron_right, size: 18, color: ThemeProvider.subtleTextColor),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(
                                              value.servedCategoriesList.length,
                                              (index) => Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: bodyText1(value.servedCategoriesList[index].name.toString()),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: DropdownButton<CityModal>(
                                          underline: const SizedBox(),
                                          isExpanded: true,
                                          style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor, fontFamily: 'regular'),
                                          icon: const Icon(Icons.keyboard_arrow_down, color: ThemeProvider.mutedTextColor),
                                          value: value.selectedCity,
                                          items: value.cityList.map((CityModal value) {
                                            return DropdownMenuItem<CityModal>(value: value, child: Text(value.name.toString()));
                                          }).toList(),
                                          onChanged: (newValue) => value.onCityChanged(newValue as CityModal),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: TextFormField(
                                        controller: value.addressTextEditor,
                                        onChanged: (String txt) {},
                                        cursorColor: ThemeProvider.appColor,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 4,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                          border: InputBorder.none,
                                          labelText: "Address".tr,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: TextFormField(
                                        controller: value.zipcode,
                                        cursorColor: ThemeProvider.appColor,
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                          border: InputBorder.none,
                                          labelText: "Zipcode".tr,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.06), borderRadius: BorderRadius.circular(14)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.place_outlined, size: 16, color: ThemeProvider.appColor),
                                            const SizedBox(width: 6),
                                            Expanded(child: Text('Set your salon location on the map :'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'regular', color: ThemeProvider.blackColor))),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton.icon(
                                            onPressed: () => value.pickLocation(),
                                            icon: const Icon(Icons.map_outlined, size: 18, color: ThemeProvider.appColor),
                                            label: Text('Pick Location on Map'.tr, style: const TextStyle(fontSize: 13, fontFamily: 'medium', color: ThemeProvider.appColor)),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: ThemeProvider.appColor,
                                              backgroundColor: ThemeProvider.whiteColor,
                                              side: const BorderSide(color: ThemeProvider.appColor),
                                              minimumSize: const Size.fromHeight(44),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Latitude & Longitude will be filled automatically once you pick a location.'.tr,
                                          style: const TextStyle(fontSize: 12, fontFamily: 'regular', color: ThemeProvider.mutedTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: textFieldDecoration(),
                                      child: TextFormField(
                                        controller: value.lat,
                                        cursorColor: ThemeProvider.appColor,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                          border: InputBorder.none,
                                          labelText: "Your Latitude".tr,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: textFieldDecoration(),
                                    child: TextFormField(
                                      controller: value.lng,
                                      keyboardType: TextInputType.number,
                                      cursorColor: ThemeProvider.appColor,
                                      style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                      decoration: InputDecoration(
                                        labelStyle: const TextStyle(fontSize: 13, color: ThemeProvider.mutedTextColor),
                                        border: InputBorder.none,
                                        labelText: "Your Longitude".tr,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ],
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

class _TypeOption extends StatelessWidget {
  const _TypeOption({required this.selected, required this.label, required this.image, required this.onTap});

  final bool selected;
  final String label;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? ThemeProvider.appColor.withOpacity(0.06) : ThemeProvider.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? ThemeProvider.appColor : ThemeProvider.dividerColor, width: selected ? 1.6 : 1),
          boxShadow: ThemeProvider.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? ThemeProvider.appColor : ThemeProvider.subtleTextColor),
                const SizedBox(width: 12),
                Text(label, style: TextStyle(fontFamily: 'bold', fontSize: 15, color: selected ? ThemeProvider.appColor : ThemeProvider.blackColor)),
              ],
            ),
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration contentButtonStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(16.0),
    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
    boxShadow: [BoxShadow(color: ThemeProvider.appColor.withOpacity(0.30), blurRadius: 16, offset: const Offset(0, 8))],
  );
}

BoxDecoration textFieldDecoration() {
  return BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.dividerColor));
}

BoxDecoration myBoxDecoration() {
  return ThemeProvider.cardDecoration();
}

Widget smallText(val) {
  return Text(val, style: const TextStyle(fontSize: 11, color: ThemeProvider.mutedTextColor));
}

Widget bodyText1(val) {
  return Text(val, style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor));
}
