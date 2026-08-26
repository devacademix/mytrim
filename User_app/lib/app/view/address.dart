import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/address_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Address'.tr, style: ThemeProvider.titleStyle),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                child: InkWell(onTap: () => value.onAddNew(), child: Center(child: Text('Add New'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'semibold', color: ThemeProvider.appColor)))),
              ),
            ],
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.addressList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 84,
                            width: 84,
                            decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), shape: BoxShape.circle),
                            child: const Icon(Icons.location_on_outlined, color: ThemeProvider.appColor, size: 36),
                          ),
                          const SizedBox(height: 20),
                          Text('No addresses saved yet'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
                          const SizedBox(height: 6),
                          Text('Add an address to speed up your bookings'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 13, color: ThemeProvider.textSecondary)),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: List.generate(
                            value.addressList.length,
                            (index) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: ThemeProvider.cardDecoration(radius: 14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                    child: const Icon(Icons.location_on_outlined, color: ThemeProvider.appColor, size: 19),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value.titles[value.addressList[index].title as int].toString(),
                                          style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14, fontFamily: 'semibold'),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${value.addressList[index].address} ${value.addressList[index].house} ${value.addressList[index].landmark} ${value.addressList[index].pincode}',
                                          style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12.5, height: 1.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => value.onEdit(value.addressList[index].id as int),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                                      child: const Icon(Icons.edit_outlined, color: ThemeProvider.appColor, size: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => value.onDestroy(value.addressList[index].id as int),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: ThemeProvider.redColor.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                                      child: const Icon(Icons.delete_outline, color: ThemeProvider.redColor, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
