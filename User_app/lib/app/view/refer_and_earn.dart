import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/refer_and_earn_controller.dart';
import 'package:user/app/util/theme.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReferAndEarnController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text('Refer & Earn'.tr, style: ThemeProvider.titleStyle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: value.apiCalled == false
                ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
                : Container(
                    decoration: ThemeProvider.cardDecoration(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(value.referralData.title.toString(), textAlign: TextAlign.center, style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'bold', fontSize: 19)),
                        const SizedBox(height: 10),
                        Text(value.referralData.message.toString(), textAlign: TextAlign.center, style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14, height: 1.5)),
                        const SizedBox(height: 16),
                        Image.asset('assets/images/gift.png', width: double.infinity, height: 240, fit: BoxFit.fitHeight),
                        const SizedBox(height: 28),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            color: ThemeProvider.surfaceTint,
                            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                            border: Border.all(color: ThemeProvider.borderColor, width: 1, style: BorderStyle.solid),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary, letterSpacing: 1),
                                  decoration: InputDecoration(border: InputBorder.none, hintText: value.myCode.toString(), hintStyle: const TextStyle(color: ThemeProvider.textPrimary)),
                                ),
                              ),
                              InkWell(
                                onTap: () => value.copyToClipBoard(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), shape: BoxShape.circle),
                                  child: const Icon(Icons.copy, size: 16, color: ThemeProvider.appColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => value.share(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeProvider.appColor,
                              foregroundColor: ThemeProvider.whiteColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                              padding: const EdgeInsets.all(0),
                            ),
                            child: Text('Invite Now'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 16)),
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
