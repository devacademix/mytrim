import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/add_review_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/star_rating.dart';
import 'package:user/app/util/theme.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddReviewController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            title: Text('${'Add Review to'.tr} ${value.name}', style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Container(
                      width: double.infinity,
                      decoration: ThemeProvider.cardDecoration(),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: ThemeProvider.borderColor, width: 2)),
                            width: 96,
                            height: 96,
                            child: FadeInImage(
                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover.toString()}'),
                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 96, width: 96);
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            value.name.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 17, fontFamily: 'bold', color: ThemeProvider.textPrimary),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Please rate the quality of service for the appointment you have got!'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15, fontFamily: 'medium', color: ThemeProvider.textPrimary, height: 1.4),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [StarRating(rating: value.rate, onRatingChanged: (rating) => value.saveRating(rating), color: ThemeProvider.secondaryAppColor)],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your comments and suggesstions help us improve the service quality better!'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, fontFamily: 'medium', color: ThemeProvider.textSecondary, height: 1.4),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.borderColor)),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: CupertinoTextField(
                              cursorColor: ThemeProvider.appColor,
                              controller: value.notesEditor,
                              placeholder: 'Write Notes'.tr,
                              placeholderStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14),
                              style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14),
                              maxLines: 4,
                              decoration: const BoxDecoration(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => value.saveReview(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeProvider.appColor,
                                  shadowColor: ThemeProvider.transparent,
                                  foregroundColor: ThemeProvider.whiteColor,
                                  elevation: 0,
                                  shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius))),
                                  padding: const EdgeInsets.all(0)),
                              child: Text(
                                'Add Review'.tr,
                                style: const TextStyle(letterSpacing: 0.5, fontSize: 16, color: ThemeProvider.whiteColor, fontFamily: 'bold'),
                              ),
                            ),
                          )
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
