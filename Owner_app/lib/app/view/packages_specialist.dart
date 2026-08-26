import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/controller/packages_specialist_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class PackagesSpecialistScreen extends StatefulWidget {
  const PackagesSpecialistScreen({super.key});

  @override
  State<PackagesSpecialistScreen> createState() => _PackagesSpecialistScreenState();
}

class _PackagesSpecialistScreenState extends State<PackagesSpecialistScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagesSpecialistController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Select Specialist'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.salonList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/no-data.png', width: 72, height: 72),
                          const SizedBox(height: 18),
                          Text('No Specialist Found!'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.mutedTextColor)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.salonList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = value.salonList[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: ThemeProvider.cardDecoration(
                            color: item.isChecked == true ? ThemeProvider.appColor.withOpacity(0.06) : ThemeProvider.whiteColor,
                          ),
                          child: Row(
                            children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(28),
                                      child: FadeInImage(
                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 56, width: 56);
                                        },
                                        fit: BoxFit.cover,
                                        width: 56,
                                        height: 56,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${item.firstName}  ${item.lastName}', overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor)),
                                        const SizedBox(height: 4),
                                        item.categories!.length <= 2
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: List.generate(
                                                  item.categories!.length,
                                                  (subIndex) => Text(
                                                    item.categories![subIndex].name.toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 12, color: ThemeProvider.mutedTextColor),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  for (var cate in item.categories!.take(2)) Text(cate.name.toString(), style: const TextStyle(fontSize: 12, color: ThemeProvider.mutedTextColor)),
                                                  Text('and more'.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.subtleTextColor)),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: ThemeProvider.appColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    value: item.isChecked,
                                    onChanged: (status) => value.updateStatus(status!, item.id as int),
                                  ),
                            ],
                          ),
                        );
                      },
                    ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            decoration: BoxDecoration(color: ThemeProvider.whiteColor, boxShadow: ThemeProvider.cardShadow),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: ThemeProvider.greenColor,
                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                        onTap: () => value.onAdd(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          child: Center(child: Text('Add'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 15, color: ThemeProvider.whiteColor))),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      color: ThemeProvider.whiteColor,
                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                        onTap: () => value.onBack(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), border: Border.all(color: ThemeProvider.redColor)),
                          child: Center(child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 15, color: ThemeProvider.redColor))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
