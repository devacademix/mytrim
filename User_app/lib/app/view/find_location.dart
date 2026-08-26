import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user/app/controller/find_location_controller.dart';
import 'package:user/app/util/theme.dart';

class FindLocationScreen extends StatefulWidget {
  const FindLocationScreen({super.key});

  @override
  State<FindLocationScreen> createState() => _FindLocationScreenState();
}

class _FindLocationScreenState extends State<FindLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FindLocationController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text('Find Location'.tr, style: ThemeProvider.titleStyle),
            actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.cancel_outlined, color: ThemeProvider.whiteColor))],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.borderColor)),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: ThemeProvider.textSecondary),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: value.searchbarText,
                            onChanged: (content) {
                              value.onSearchChanged(content);
                            },
                            decoration: InputDecoration(border: InputBorder.none, hintText: 'Search location'.tr, hintStyle: const TextStyle(color: ThemeProvider.textSecondary), contentPadding: const EdgeInsets.symmetric(vertical: 14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                value.getList.isNotEmpty
                    ? Container(
                        decoration: ThemeProvider.cardDecoration(),
                        child: Column(
                          children: [
                            for (var item in value.getList)
                              InkWell(
                                borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                                onTap: () => value.getLatLngFromAddress(item.description.toString()),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, color: ThemeProvider.appColor, size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item.description!.length > 40 ? '${item.description!.substring(0, 40)}...' : item.description!,
                                          style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    : const SizedBox(),
                value.getList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TextButton.icon(
                          onPressed: () => value.getLocation(),
                          icon: const Icon(Icons.my_location, color: ThemeProvider.appColor, size: 18),
                          label: Text('Use My Current Location'.tr.toUpperCase(), style: const TextStyle(color: ThemeProvider.appColor, letterSpacing: 0.6, fontFamily: 'semibold')),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(height: value.getList.isEmpty ? 16 : 0),
                value.getList.isEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                        child: SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: GoogleMap(onMapCreated: value.onMapCreated, markers: value.markers, initialCameraPosition: CameraPosition(target: LatLng(value.myLat, value.myLng), zoom: 15)),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(height: value.getList.isEmpty ? 20 : 0),
                value.isConfirmed == true
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => value.onConfirmLocation(),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: ThemeProvider.whiteColor,
                            backgroundColor: ThemeProvider.appColor,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text('Confirm Location'.tr.toUpperCase(), style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 14, fontFamily: 'semibold', letterSpacing: 0.6)),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
