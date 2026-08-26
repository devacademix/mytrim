import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/languages_controller.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';

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
            leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: ThemeProvider.cardDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  for (var language in AppConstants.languages)
                    RadioListTile(
                      value: language.languageCode,
                      groupValue: value.languageCode,
                      onChanged: (e) => value.saveLanguages(e.toString()),
                      activeColor: ThemeProvider.appColor,
                      title: Text(language.languageName, style: const TextStyle(fontFamily: 'medium', fontSize: 15, color: ThemeProvider.textPrimary)),
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
