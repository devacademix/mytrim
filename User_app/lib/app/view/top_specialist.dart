import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/top_specialist_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class TopSpecialistScreen extends StatefulWidget {
  const TopSpecialistScreen({super.key});

  @override
  State<TopSpecialistScreen> createState() => _TopSpecialistScreenState();
}

class _TopSpecialistScreenState extends State<TopSpecialistScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopSpecialistController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Top Specialist'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: List.generate(
                      6,
                      (index) => Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: ThemeProvider.cardDecoration(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: SkeletonLine(style: SkeletonLineStyle(height: 80, width: 80, borderRadius: BorderRadius.circular(14))),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SkeletonParagraph(
                                    style: SkeletonParagraphStyle(
                                      lines: 1,
                                      spacing: 2,
                                      lineStyle: SkeletonLineStyle(randomLength: true, height: 20, borderRadius: BorderRadius.circular(8), minLength: MediaQuery.of(context).size.width),
                                    ),
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
              : value.topFreelancerList.isNotEmpty
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          children: [
                            for (var item in value.topFreelancerList)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 14),
                                decoration: ThemeProvider.cardDecoration(),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(40),
                                            child: FadeInImage(
                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.userInfo?.cover.toString()}'),
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
                                              Text(
                                                '${item.userInfo!.firstName} ${item.userInfo!.lastName}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.textPrimary),
                                              ),
                                              const SizedBox(height: 6),
                                              Wrap(
                                                spacing: 6,
                                                runSpacing: 6,
                                                children: (item.categories!.length <= 2 ? item.categories! : item.categories!.take(2).toList())
                                                    .map<Widget>((cate) => _buildPillChip(cate.name.toString()))
                                                    .toList()
                                                  ..addAll(item.categories!.length > 2 ? [_buildPillChip('and more'.tr)] : []),
                                              ),
                                              const SizedBox(height: 6),
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(height: 1, color: ThemeProvider.borderColor),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(text: 'Fee start from '.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                              TextSpan(
                                                text: value.currencySide == 'left' ? value.currencySymbol + item.feeStart.toString() : item.feeStart.toString() + value.currencySymbol,
                                                style: const TextStyle(fontSize: 15, color: ThemeProvider.appColor, fontFamily: 'semibold'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => value.onSpecialist(item.uid as int),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                    )
                  : _buildEmptyState('No Data Found Near You!'.tr),
        );
      },
    );
  }

  Widget _buildPillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
      child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: ThemeProvider.appColor, fontFamily: 'medium')),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.06)),
              child: const Icon(Icons.person_search_outlined, size: 40, color: ThemeProvider.appColor),
            ),
            const SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
          ],
        ),
      ),
    );
  }
}
