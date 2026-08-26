import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/coupon_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Select Coupon'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.couponList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.08)),
                            child: const Icon(Icons.local_offer_outlined, size: 40, color: ThemeProvider.appColor),
                          ),
                          const SizedBox(height: 20),
                          Text('No coupons available'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        children: List.generate(
                          value.couponList.length,
                          (index) {
                            final bool selected = value.selectedCouponCode == value.couponList[index].id.toString();
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: ThemeProvider.surfaceColor,
                                borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                                boxShadow: ThemeProvider.cardShadow,
                                border: Border.all(color: selected ? ThemeProvider.appColor : ThemeProvider.borderColor, width: selected ? 1.5 : 1),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                                onTap: () => value.saveCoupon(value.couponList[index].id as int),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                                        child: const Icon(Icons.local_offer_outlined, color: ThemeProvider.appColor, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Use coupon code '.tr + value.couponList[index].name.toString(),
                                                style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.textPrimary)),
                                            const SizedBox(height: 4),
                                            Text(
                                              value.couponList[index].shortDescriptions.toString() + ' - Valid until '.tr + value.couponList[index].expire.toString(),
                                              style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? ThemeProvider.appColor : ThemeProvider.borderColor),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => value.onSaveCoupon(),
                  style: ElevatedButton.styleFrom(backgroundColor: ThemeProvider.greenColor, elevation: 0, shape: const StadiumBorder()),
                  child: Text('Save'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 16)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
