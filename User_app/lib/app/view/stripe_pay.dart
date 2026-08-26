import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/stripe_pay_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class StripePay extends StatefulWidget {
  const StripePay({super.key});

  @override
  State<StripePay> createState() => _StripePayState();
}

class _StripePayState extends State<StripePay> {
  Color getColor(Set<WidgetState> states) {
    return ThemeProvider.appColor;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StripePayController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
            title: Text('Pay With Stripe'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                        onTap: () => value.onAddCard(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                            color: ThemeProvider.appColor.withOpacity(0.06),
                            border: Border.all(color: ThemeProvider.appColor.withOpacity(0.25)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_circle_outline, color: ThemeProvider.appColor, size: 20),
                              const SizedBox(width: 10),
                              Text('Add New Card'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.appColor)),
                            ],
                          ),
                        ),
                      ),
                      value.cardsListCalled == false ? Column(children: [SizedBox(height: 400, child: SkeletonListView())]) : const SizedBox(),
                      const SizedBox(height: 20),
                      for (var item in value.cards)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: ThemeProvider.cardDecoration(),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.credit_card, color: ThemeProvider.appColor, size: 20),
                              ),
                              title: Text('XXXX XXXX XXXX ${item.last4.toString().toUpperCase()}', style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'medium', fontSize: 14)),
                              subtitle: Text('${'Expiry '.tr}${item.expMonth} / ${item.expYear}', style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12)),
                              trailing: Radio(
                                fillColor: WidgetStateProperty.resolveWith(getColor),
                                value: item.id.toString(),
                                groupValue: value.selectedCard,
                                onChanged: (e) => value.saveCardToPay(e.toString()),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => value.createPayment(),
              style: ElevatedButton.styleFrom(
                foregroundColor: ThemeProvider.whiteColor,
                backgroundColor: ThemeProvider.appColor,
                elevation: 0,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Payment'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'semibold')),
            ),
          ),
        );
      },
    );
  }
}
