import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/categories_list_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesListController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text(value.selectedCateName, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(randomLength: true, height: 20, borderRadius: BorderRadius.circular(8), minLength: MediaQuery.of(context).size.width / 5),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            7,
                            (index) => const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: SkeletonAvatar(style: SkeletonAvatarStyle(shape: BoxShape.circle, width: 60, height: 60))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(randomLength: true, height: 20, borderRadius: BorderRadius.circular(8), minLength: MediaQuery.of(context).size.width / 5),
                          ),
                        ),
                      ),
                      Column(
                        children: List.generate(
                          10,
                          (index) => Container(
                            padding: const EdgeInsets.all(14),
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: ThemeProvider.cardDecoration(),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: SkeletonLine(style: SkeletonLineStyle(height: 80, width: 80, borderRadius: BorderRadius.circular(ThemeProvider.cardRadius))),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          SkeletonParagraph(
                                            style: SkeletonParagraphStyle(
                                              lines: 1,
                                              spacing: 6,
                                              lineStyle: SkeletonLineStyle(
                                                randomLength: true,
                                                height: 20,
                                                borderRadius: BorderRadius.circular(8),
                                                minLength: MediaQuery.of(context).size.width / 3,
                                              ),
                                            ),
                                          ),
                                          SkeletonParagraph(
                                            style: SkeletonParagraphStyle(
                                              lines: 1,
                                              spacing: 6,
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
                                              spacing: 6,
                                              lineStyle: SkeletonLineStyle(
                                                randomLength: true,
                                                height: 10,
                                                borderRadius: BorderRadius.circular(8),
                                                minLength: MediaQuery.of(context).size.width / 7,
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
                      )
                    ],
                  ),
                )
              : value.haveData == true
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (value.individualCateList.isNotEmpty) ...[
                              Text('Specialist'.tr, style: const TextStyle(fontSize: 16, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 96,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (var item in value.individualCateList)
                                        GestureDetector(
                                          onTap: () => value.onSpecialist(item.uid as int),
                                          child: Container(
                                            width: 76,
                                            margin: const EdgeInsets.only(right: 14),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ThemeProvider.borderColor, width: 1), boxShadow: ThemeProvider.cardShadow, color: ThemeProvider.surfaceColor),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: SizedBox.fromSize(
                                                      size: const Size.fromRadius(28),
                                                      child: FadeInImage(
                                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.userInfo!.cover}'),
                                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                        imageErrorBuilder: (context, error, stackTrace) {
                                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                                        },
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${item.userInfo!.firstName} ${item.userInfo!.lastName}',
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary, fontFamily: 'medium'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                            Text('Salon'.tr, style: const TextStyle(fontSize: 16, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                            const SizedBox(height: 12),
                            if (value.salonCateList.isEmpty)
                              _buildEmptyState('No Data Found Near You!'.tr)
                            else
                              for (var item in value.salonCateList)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: ThemeProvider.cardDecoration(),
                                  child: InkWell(
                                    onTap: () => value.onServices(item.uid as int),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(40),
                                            child: FadeInImage(
                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                              },
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item.name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.textPrimary)),
                                              const SizedBox(height: 4),
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
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.06)),
              child: const Icon(Icons.storefront_outlined, size: 40, color: ThemeProvider.appColor),
            ),
            const SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
          ],
        ),
      ),
    );
  }
}
