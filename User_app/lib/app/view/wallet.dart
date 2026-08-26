import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/wallet_controller.dart';
import 'package:user/app/util/theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text('Wallet'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                          gradient: LinearGradient(colors: [ThemeProvider.appColor, ThemeProvider.appColorDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          boxShadow: [BoxShadow(color: ThemeProvider.appColor.withOpacity(0.28), blurRadius: 20, offset: const Offset(0, 10))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: ThemeProvider.whiteColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.account_balance_wallet_outlined, color: ThemeProvider.whiteColor, size: 18),
                                ),
                                const SizedBox(width: 10),
                                Text('Available Balance'.tr, style: TextStyle(fontFamily: 'medium', fontSize: 13, color: ThemeProvider.whiteColor.withOpacity(0.85))),
                              ],
                            ),
                            const SizedBox(height: 14),
                            value.currencySide == 'left'
                                ? Text('${value.currencySymbol}${value.amount}', style: const TextStyle(fontSize: 30, fontFamily: 'bold', color: ThemeProvider.whiteColor))
                                : Text('${value.amount}${value.currencySymbol}', style: const TextStyle(fontSize: 30, fontFamily: 'bold', color: ThemeProvider.whiteColor)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('All Transactions'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 15, color: ThemeProvider.textPrimary)),
                      const SizedBox(height: 12),
                      value.walletList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text('No transactions yet'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textSecondary)),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                value.walletList.length,
                                (index) {
                                  final bool isCredit = !value.walletList[index].amount.toString().startsWith('-');
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: ThemeProvider.cardDecoration(),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(9),
                                          decoration: BoxDecoration(
                                            color: (isCredit ? ThemeProvider.greenColor : ThemeProvider.redColor).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                                            color: isCredit ? ThemeProvider.greenColor : ThemeProvider.redColor,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(value.walletList[index].type.toString().toUpperCase(), style: const TextStyle(fontFamily: 'semibold', fontSize: 13, color: ThemeProvider.textPrimary)),
                                              const SizedBox(height: 2),
                                              Text(value.walletList[index].uuid.toString(), style: const TextStyle(fontFamily: 'regular', fontSize: 11, color: ThemeProvider.textSecondary)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            value.currencySide == 'left'
                                                ? Text('${value.currencySymbol}${value.walletList[index].amount}', style: const TextStyle(fontSize: 13, fontFamily: 'semibold', color: ThemeProvider.textPrimary))
                                                : Text('${value.walletList[index].amount}${value.currencySymbol}', style: const TextStyle(fontSize: 13, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                            const SizedBox(height: 2),
                                            Text(value.walletList[index].createdAt.toString(), style: const TextStyle(fontFamily: 'regular', fontSize: 11, color: ThemeProvider.textSecondary)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
