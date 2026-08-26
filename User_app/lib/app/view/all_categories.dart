import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/all_categories_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('All Categories'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 90 / 100),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    children: List.generate(9, (index) => SkeletonLine(style: SkeletonLineStyle(height: 130, width: 120, borderRadius: BorderRadius.circular(ThemeProvider.cardRadius)))),
                  ),
                )
              : value.categoriesList.isNotEmpty
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(12.0),
                      child: GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 90 / 100),
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        children: [
                          for (var item in value.categoriesList)
                            InkWell(
                              borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                              onTap: () => value.onCategoriesList(item.id as int, item.name.toString()),
                              child: Container(
                                decoration: ThemeProvider.cardDecoration(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        height: 64,
                                        width: 64,
                                        color: ThemeProvider.appColor.withOpacity(0.06),
                                        padding: const EdgeInsets.all(10.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
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
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        item.name.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary, fontFamily: 'medium'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : _buildEmptyState('No Data Found!'.tr),
        );
      },
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
              child: const Icon(Icons.grid_view_rounded, size: 40, color: ThemeProvider.appColor),
            ),
            const SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
          ],
        ),
      ),
    );
  }
}
