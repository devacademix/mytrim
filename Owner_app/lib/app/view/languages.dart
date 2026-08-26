import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/languages_controller.dart';
import 'package:owner/app/util/constance.dart';
import 'package:owner/app/util/theme.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguagesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            title: Text('Languages'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Container(
              decoration: ThemeProvider.cardDecoration(),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var language in AppConstants.languages)
                    InkWell(
                      onTap: () => value.saveLanguages(language.languageCode.toString()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: language == AppConstants.languages.last ? ThemeProvider.transparent : ThemeProvider.dividerColor)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.language, size: 18, color: ThemeProvider.appColor),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(language.languageName, style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.blackColor)),
                            ),
                            Icon(
                              value.languageCode == language.languageCode ? Icons.radio_button_checked : Icons.radio_button_off,
                              size: 20,
                              color: value.languageCode == language.languageCode ? ThemeProvider.appColor : ThemeProvider.subtleTextColor,
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
