import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/add_card_controller.dart';
import 'package:user/app/util/theme.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  static const _fieldLabelStyle = TextStyle(fontFamily: 'medium', fontSize: 13, color: ThemeProvider.textSecondary);

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      hintStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14),
    );
  }

  Widget _fieldWrap({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _fieldLabelStyle),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeProvider.surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ThemeProvider.borderColor),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddCardController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            title: Text('Add New Card'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldWrap(
                        label: 'Email Address'.tr,
                        child: TextField(
                          controller: value.emailAddress,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textPrimary),
                          decoration: _fieldDecoration('Email Address'.tr),
                        ),
                      ),
                      _fieldWrap(
                        label: 'Card Holder Name'.tr,
                        child: TextField(
                          controller: value.cardName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textPrimary),
                          decoration: _fieldDecoration('Card Holder Name'.tr),
                        ),
                      ),
                      _fieldWrap(
                        label: 'Card Number'.tr,
                        child: TextField(
                          controller: value.cardNumber,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [CreditCardNumberInputFormatter()],
                          style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textPrimary),
                          decoration: _fieldDecoration('Card Number'.tr),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _fieldWrap(
                              label: 'CVV'.tr,
                              child: TextField(
                                controller: value.cvcNumber,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                inputFormatters: [CreditCardCvcInputFormatter()],
                                style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textPrimary),
                                decoration: _fieldDecoration('CVV'.tr),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _fieldWrap(
                              label: 'MM/YY'.tr,
                              child: TextField(
                                controller: value.expireNumber,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                inputFormatters: [CreditCardExpirationDateFormatter()],
                                style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textPrimary),
                                decoration: _fieldDecoration('MM/YY'.tr),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => value.submitData(),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: ThemeProvider.whiteColor,
                            backgroundColor: ThemeProvider.appColor,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text('ADD CARD'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'semibold', letterSpacing: 0.5)),
                        ),
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }
}
