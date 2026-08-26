import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/packages_categories_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class PackagesCategoriesScreen extends StatefulWidget {
  const PackagesCategoriesScreen({super.key});

  @override
  State<PackagesCategoriesScreen> createState() => _PackagesCategoriesScreen();
}

class _PackagesCategoriesScreen extends State<PackagesCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagesCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Select Packages'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.servicesList.isEmpty
                  ? _EmptyState(message: 'No Services Found'.tr)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.servicesList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final item = value.servicesList[i];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: ThemeProvider.cardDecoration(radius: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 56, width: 56);
                                      },
                                      fit: BoxFit.cover,
                                      height: 56,
                                      width: 56,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: const BoxDecoration(
                                        color: ThemeProvider.orangeColor,
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), topRight: Radius.circular(10)),
                                      ),
                                      child: Text(
                                        '${item.discount.toString()}%',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.whiteColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor)),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.webCatesData!.name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(text: '${item.off} \$  '.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.subtleTextColor, decoration: TextDecoration.lineThrough)),
                                          TextSpan(text: '  ${item.price} \$'.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.appColor, fontFamily: 'bold')),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Icon(Icons.schedule, size: 12, color: ThemeProvider.subtleTextColor),
                                        const SizedBox(width: 3),
                                        Text('${item.duration} min', overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                checkColor: ThemeProvider.whiteColor,
                                activeColor: ThemeProvider.appColor,
                                value: item.isChecked,
                                onChanged: (status) => value.updateStatus(status!, item.id as int),
                              ),
                            ],
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
