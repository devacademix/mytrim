import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/top_offers_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class TopOffersScreen extends StatefulWidget {
  const TopOffersScreen({super.key});

  @override
  State<TopOffersScreen> createState() => _TopOffersScreenState();
}

class _TopOffersScreenState extends State<TopOffersScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopOffersController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Top Salon'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 16, color: ThemeProvider.whiteColor)),
          ),
          body: value.apiCalled == false
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      10,
                      (index) => Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: ThemeProvider.cardDecoration(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: SkeletonLine(style: SkeletonLineStyle(height: 80, width: 80, borderRadius: BorderRadius.circular(5))),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SkeletonParagraph(
                                        style: SkeletonParagraphStyle(
                                          lines: 1,
                                          spacing: 2,
                                          lineStyle: SkeletonLineStyle(randomLength: true, height: 20, borderRadius: BorderRadius.circular(8), minLength: MediaQuery.of(context).size.width),
                                        ),
                                      ),
                                      SkeletonParagraph(
                                        style: SkeletonParagraphStyle(
                                          lines: 1,
                                          spacing: 2,
                                          lineStyle: SkeletonLineStyle(
                                            randomLength: true,
                                            height: 10,
                                            borderRadius: BorderRadius.circular(8),
                                            minLength: MediaQuery.of(context).size.width / 7,
                                          ),
                                        ),
                                      ),
                                      SkeletonParagraph(
                                        style: SkeletonParagraphStyle(
                                          lines: 1,
                                          spacing: 2,
                                          lineStyle: SkeletonLineStyle(
                                            randomLength: true,
                                            height: 5,
                                            borderRadius: BorderRadius.circular(8),
                                            minLength: MediaQuery.of(context).size.width / 5,
                                          ),
                                        ),
                                      ),
                                      SkeletonParagraph(
                                        style: SkeletonParagraphStyle(
                                          lines: 1,
                                          spacing: 2,
                                          lineStyle: SkeletonLineStyle(
                                            randomLength: true,
                                            height: 5,
                                            borderRadius: BorderRadius.circular(8),
                                            minLength: MediaQuery.of(context).size.width / 3,
                                          ),
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
                    ),
                  ),
                )
              : value.topSalonList.isNotEmpty
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          children: [
                            for (var item in value.topSalonList)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: ThemeProvider.cardDecoration(),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(40),
                                        child: FadeInImage(
                                          image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
                                          placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                          imageErrorBuilder: (context, error, stackTrace) {
                                            return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                          },
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
                                          const SizedBox(height: 2),
                                          Text(item.address.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(child: Icon(Icons.star, size: 15, color: item.rating! >= 1 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                                    WidgetSpan(child: Icon(Icons.star, size: 15, color: item.rating! >= 2 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                                    WidgetSpan(child: Icon(Icons.star, size: 15, color: item.rating! >= 3 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                                    WidgetSpan(child: Icon(Icons.star, size: 15, color: item.rating! >= 4 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                                    WidgetSpan(child: Icon(Icons.star, size: 15, color: item.rating! >= 5 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => value.onServices(item.uid as int),
                                                borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                  decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                  child: Text('Continue'.tr, style: const TextStyle(fontSize: 11, fontFamily: 'semibold', color: ThemeProvider.whiteColor)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        SizedBox(height: 100, width: 100, child: Image.asset("assets/images/no-data.png", fit: BoxFit.cover)),
                        const SizedBox(height: 20),
                        Center(child: Text('No Data Found Near You!'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 16, color: ThemeProvider.textPrimary))),
                      ],
                    ),
        );
      },
    );
  }
}
