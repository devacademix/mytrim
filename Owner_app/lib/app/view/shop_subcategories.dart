import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/shop_subcategories_controller.dart';
import 'package:owner/app/util/theme.dart';

class ShopSubCategoriesScreen extends StatefulWidget {
  const ShopSubCategoriesScreen({super.key});

  @override
  State<ShopSubCategoriesScreen> createState() => _ShopSubCategoriesScreenState();
}

class _ShopSubCategoriesScreenState extends State<ShopSubCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopSubCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Select Shop Subcategories'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.subCateList.isEmpty
                  ? _EmptyState(message: 'No Subcategories Found'.tr)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.subCateList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => Container(
                        decoration: ThemeProvider.cardDecoration(radius: 14),
                        clipBehavior: Clip.antiAlias,
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                          activeColor: ThemeProvider.appColor,
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.label_outline, size: 18, color: ThemeProvider.appColor),
                          ),
                          value: value.subCateList[i].id.toString(),
                          groupValue: value.selectedSubCate,
                          onChanged: (data) => value.saveSubCate(data.toString()),
                          title: Text(value.subCateList[i].name.toString(), style: const TextStyle(fontFamily: 'medium', fontSize: 14, color: ThemeProvider.blackColor)),
                        ),
                      ),
                    ),
          bottomNavigationBar: SizedBox(
            height: 76,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => value.saveAndClose(),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(14, 10, 7, 14),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(color: ThemeProvider.greenColor, borderRadius: BorderRadius.circular(14), boxShadow: ThemeProvider.cardShadow),
                      child: Center(child: Text('Save'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.whiteColor))),
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
