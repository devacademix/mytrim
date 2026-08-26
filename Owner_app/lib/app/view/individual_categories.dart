import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/individual_categories_controller.dart';
import 'package:owner/app/util/theme.dart';

class IndividualCategoriesScreen extends StatefulWidget {
  const IndividualCategoriesScreen({super.key});

  @override
  State<IndividualCategoriesScreen> createState() => _IndividualCategoriesScreenState();
}

class _IndividualCategoriesScreenState extends State<IndividualCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualprofileCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Select Individual Categories'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.categories.isEmpty
                  ? _EmptyState(message: 'No Categories Found'.tr)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = value.categories[index];
                        return Container(
                          decoration: ThemeProvider.cardDecoration(radius: 14),
                          clipBehavior: Clip.antiAlias,
                          child: CheckboxListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                            controlAffinity: ListTileControlAffinity.trailing,
                            secondary: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.category_outlined, size: 18, color: ThemeProvider.appColor),
                            ),
                            title: Text(item.name.toString(), style: const TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.blackColor)),
                            checkColor: ThemeProvider.whiteColor,
                            activeColor: ThemeProvider.appColor,
                            value: item.isChecked,
                            onChanged: (status) => value.updateStatus(status!, item.id as int),
                          ),
                        );
                      },
                    ),
          bottomNavigationBar: SizedBox(
            height: 76,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => value.updateCate(),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(14, 10, 7, 14),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(color: ThemeProvider.greenColor, borderRadius: BorderRadius.circular(14), boxShadow: ThemeProvider.cardShadow),
                      child: Center(child: Text('Update'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.whiteColor))),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
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
