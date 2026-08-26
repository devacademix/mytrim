import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/app_pages_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AppPagesScreen extends StatefulWidget {
  const AppPagesScreen({super.key});

  @override
  State<AppPagesScreen> createState() => _AppPagesScreenState();
}

class _AppPagesScreenState extends State<AppPagesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppPagesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text(value.title, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == true
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: ThemeProvider.cardDecoration(),
                    child: Wrap(children: [HtmlWidget(value.content.toString())]),
                  ),
                )
              : buildDummy(),
        );
      },
    );
  }

  Widget buildDummy() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: ThemeProvider.cardDecoration(),
          child: SkeletonItem(
            child: Column(
              children: [
                Row(
                  children: [
                    const SkeletonAvatar(style: SkeletonAvatarStyle(shape: BoxShape.circle, width: 50, height: 50)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                          lines: 3,
                          spacing: 6,
                          lineStyle: SkeletonLineStyle(
                            randomLength: true,
                            height: 10,
                            borderRadius: BorderRadius.circular(8),
                            minLength: MediaQuery.of(context).size.width / 6,
                            maxLength: MediaQuery.of(context).size.width / 3,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 3,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(randomLength: true, height: 10, borderRadius: BorderRadius.circular(8), minLength: MediaQuery.of(context).size.width / 2),
                  ),
                ),
                const SizedBox(height: 12),
                SkeletonAvatar(style: SkeletonAvatarStyle(width: double.infinity, minHeight: MediaQuery.of(context).size.height / 8, maxHeight: MediaQuery.of(context).size.height / 3)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        SkeletonAvatar(style: SkeletonAvatarStyle(width: 20, height: 20)),
                        SizedBox(width: 8),
                        SkeletonAvatar(style: SkeletonAvatarStyle(width: 20, height: 20)),
                        SizedBox(width: 8),
                        SkeletonAvatar(style: SkeletonAvatarStyle(width: 20, height: 20)),
                      ],
                    ),
                    SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8)))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
