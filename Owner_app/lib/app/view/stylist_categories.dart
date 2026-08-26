import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/stylist_categories_controller.dart';
import 'package:owner/app/util/theme.dart';

class StylistCategoriesScreen extends StatefulWidget {
  const StylistCategoriesScreen({super.key});

  @override
  State<StylistCategoriesScreen> createState() => _StylistCategoriesScreen();
}

class _StylistCategoriesScreen extends State<StylistCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StylistCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Select Stylist'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: List.generate(
                        20,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 2,
                              lineStyle: SkeletonLineStyle(randomLength: true, height: 20, borderRadius: BorderRadius.circular(8), minLength: MediaQuery.of(context).size.width),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : value.selectEditProfileList.isEmpty
                  ? _EmptyState(message: 'No Stylist Found'.tr)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.selectEditProfileList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = value.selectEditProfileList[index];
                        return Container(
                          decoration: ThemeProvider.cardDecoration(radius: 14),
                          clipBehavior: Clip.antiAlias,
                          child: CheckboxListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                            controlAffinity: ListTileControlAffinity.trailing,
                            secondary: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.style_outlined, size: 18, color: ThemeProvider.appColor),
                            ),
                            title: Text(item.name.toString(), style: const TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.blackColor)),
                            checkColor: ThemeProvider.whiteColor,
                            activeColor: ThemeProvider.appColor,
                            value: item.isChecked,
                            onChanged: (status) => value.updateStatus(status!, item.id as int, item.name.toString()),
                          ),
                        );
                      },
                    ),
          bottomNavigationBar: SizedBox(
            height: 76,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => value.onAdd(),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(14, 10, 7, 14),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(color: ThemeProvider.greenColor, borderRadius: BorderRadius.circular(14), boxShadow: ThemeProvider.cardShadow),
                      child: Center(child: Text('Add'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.whiteColor))),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => value.onBack(),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(7, 10, 14, 14),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(color: ThemeProvider.redColor, borderRadius: BorderRadius.circular(14), boxShadow: ThemeProvider.cardShadow),
                      child: Center(child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.whiteColor))),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/no-data.png', width: 72, height: 72),
          const SizedBox(height: 18),
          Text(message, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.mutedTextColor)),
        ],
      ),
    );
  }
}
