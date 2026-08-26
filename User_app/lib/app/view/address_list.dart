import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/address_list_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressListController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          bottomNavigationBar: value.addressList.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: const BoxDecoration(color: ThemeProvider.whiteColor),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => value.saveAndClose(),
                            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), color: ThemeProvider.appColor),
                              child: Center(child: Text('Save'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 15))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), border: Border.all(color: ThemeProvider.borderColor, width: 1)),
                              child: Center(child: Text('Cancle'.tr, style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'semibold', fontSize: 15))),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Select Address'.tr, style: ThemeProvider.titleStyle),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                child: InkWell(
                  onTap: () => value.onNewAddress(),
                  child: Center(child: Text('Add Address'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'semibold', color: ThemeProvider.appColor))),
                ),
              ),
            ],
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: value.addressList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: value.addressList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              final bool selected = value.selectedAddressId == value.addressList[i].id.toString();
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: ThemeProvider.surfaceColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: selected ? ThemeProvider.appColor : ThemeProvider.borderColor, width: selected ? 1.5 : 1),
                                  boxShadow: ThemeProvider.cardShadow,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => value.saveAdd(value.addressList[i].id.toString()),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                          child: const Icon(Icons.location_on_outlined, color: ThemeProvider.appColor, size: 18),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(value.titles[value.addressList[i].title as int].toString(),
                                                  style: const TextStyle(fontSize: 14, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${value.addressList[i].address} '
                                                ' ${value.addressList[i].house} '
                                                ' ${value.addressList[i].landmark} '
                                                ' ${value.addressList[i].pincode}',
                                                style: const TextStyle(fontSize: 12.5, color: ThemeProvider.textSecondary, height: 1.4),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Radio(
                                          activeColor: ThemeProvider.appColor,
                                          value: value.addressList[i].id.toString(),
                                          groupValue: value.selectedAddressId,
                                          onChanged: (data) => value.saveAdd(data.toString()),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              Container(
                                height: 84,
                                width: 84,
                                decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), shape: BoxShape.circle),
                                child: const Icon(Icons.location_on_outlined, color: ThemeProvider.appColor, size: 36),
                              ),
                              const SizedBox(height: 20),
                              Text('No Data Found!'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
                            ],
                          ),
                  ),
                ),
        );
      },
    );
  }
}
