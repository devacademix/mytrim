import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/choose_location_controller.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  Widget getLanguages() {
    return PopupMenuButton(
      onSelected: (value) {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.translate, color: ThemeProvider.appColor, size: 20),
        ),
      ),
      itemBuilder: (context) => AppConstants.languages
          .map((e) => PopupMenuItem<String>(
              value: e.languageCode.toString(),
              onTap: () {
                var locale = Locale(e.languageCode.toString());
                Get.updateLocale(locale);
                Get.find<ChooseLocationController>().saveLanguage(e.languageCode);
              },
              child: Text(e.languageName.toString())))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChooseLocationController>(
      builder: (value) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(elevation: 0, automaticallyImplyLeading: false, backgroundColor: ThemeProvider.transparent, title: const Row(mainAxisAlignment: MainAxisAlignment.end), actions: <Widget>[getLanguages()]),
          backgroundColor: ThemeProvider.whiteColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(width: 260, height: 260, decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.06))),
                        Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.08))),
                        Image.asset('assets/images/1.png', height: 220, fit: BoxFit.contain),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Access Your'.tr, style: const TextStyle(fontFamily: 'medium', fontSize: 18, color: ThemeProvider.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Location'.tr, textAlign: TextAlign.center, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 26, fontFamily: 'bold')),
                        const SizedBox(height: 12),
                        Text(
                          'We use your location to show nearby salons, barbers and specialists available for booking'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: ThemeProvider.textSecondary, height: 1.5),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => value.getLocation(),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ThemeProvider.whiteColor,
                              backgroundColor: ThemeProvider.appColor,
                              elevation: 0,
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text('USE CURRENT LOCATION'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 14, fontFamily: 'semibold', letterSpacing: 0.6)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => value.onChooseLocation(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ThemeProvider.appColor,
                              backgroundColor: ThemeProvider.whiteColor,
                              side: const BorderSide(color: ThemeProvider.borderColor),
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text('CHOOSE LOCATION'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'semibold', letterSpacing: 0.6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
