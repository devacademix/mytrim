import 'package:flutter/material.dart';
import 'package:owner/app/controller/register_categories_controller.dart';
import 'package:get/get.dart';
import 'package:owner/app/util/theme.dart';

class RegisterCategoryScreen extends StatefulWidget {
  const RegisterCategoryScreen({super.key});

  @override
  State<RegisterCategoryScreen> createState() => _RegisterCategoryScreenState();
}

class _RegisterCategoryScreenState extends State<RegisterCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text('Served Category'.tr, style: ThemeProvider.titleStyle),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => value.saveAndClose(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ThemeProvider.whiteColor,
                        backgroundColor: ThemeProvider.appColor,
                        shadowColor: ThemeProvider.appColor.withOpacity(0.35),
                        elevation: 2,
                        shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text('Save'.tr),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ThemeProvider.appColor,
                        side: const BorderSide(color: ThemeProvider.appColor),
                        shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text('Cancle'.tr),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : value.servedCategoriesList.isEmpty
                  ? _EmptyState(message: 'No Categories Found'.tr)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.servedCategoriesList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = value.servedCategoriesList[index];
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
