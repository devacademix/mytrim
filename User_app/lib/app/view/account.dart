import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/env.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(value.parser.haveLoggedIn() == true ? 210 : 120),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
              child: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ThemeProvider.appColor, ThemeProvider.appColorDark])),
                child: SafeArea(
                  bottom: false,
                  child: value.parser.haveLoggedIn() == true
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 78,
                                width: 78,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(border: Border.all(color: ThemeProvider.whiteColor.withOpacity(0.9), width: 2), shape: BoxShape.circle),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: FadeInImage(
                                    height: 70,
                                    width: 70,
                                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                    },
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text('${value.firstName} ${value.lastName}', style: const TextStyle(fontFamily: 'semibold', fontSize: 17, color: ThemeProvider.whiteColor)),
                              const SizedBox(height: 3),
                              Text(value.email, style: TextStyle(color: ThemeProvider.whiteColor.withOpacity(0.78), fontSize: 12, fontFamily: 'regular')),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('Account'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 24, color: ThemeProvider.whiteColor)),
                          ),
                        ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionCard([
                    value.parser.haveLoggedIn() == false ? _buildList(Icons.lock_clock_outlined, 'Sign In / Sign Up'.tr, onTap: () => value.onLogin()) : null,
                    value.parser.haveLoggedIn() == true ? _buildList(Icons.account_circle_outlined, 'Edit Profile'.tr, onTap: () => value.onEdit()) : null,
                    value.parser.haveLoggedIn() == true ? _buildList(Icons.add_shopping_cart, 'Product Order'.tr, onTap: () => value.onProductOrder()) : null,
                    value.parser.haveLoggedIn() == true ? _buildList(Icons.location_on_outlined, 'Your Address'.tr, onTap: () => value.onAddress()) : null,
                    value.parser.haveLoggedIn() == true ? _buildList(Icons.account_balance_wallet_outlined, 'Wallet'.tr, onTap: () => value.onWallet()) : null,
                    value.parser.haveLoggedIn() == true ? _buildList(Icons.savings_outlined, 'Refer & Earn'.tr, onTap: () => value.onReferAndEarn()) : null,
                    _buildList(Icons.code_rounded, 'Change Password'.tr, onTap: () => value.onChangePassword()),
                    _buildList(Icons.language_outlined, 'Languages'.tr, onTap: () => value.onLanguages()),
                    value.parser.haveLoggedIn() == true ? _buildList(Icons.message_outlined, 'Chats'.tr, onTap: () => value.onAccountChat()) : null,
                    _buildList(Icons.contact_page_outlined, 'Contact Us'.tr, onTap: () => value.onContactUs(), isLast: true),
                  ]),
                  const SizedBox(height: 16),
                  _sectionCard([
                    _buildList(Icons.flag_outlined, 'Frequently Asked Questions'.tr, onTap: () => value.onAppPages('Frequently Asked Questions'.tr, '5')),
                    _buildList(Icons.help_outline, 'Help'.tr, onTap: () => value.onAppPages('Help'.tr, '6')),
                    _buildList(Icons.security_outlined, 'Privacy Policy'.tr, onTap: () => value.onAppPages('Privacy Policy'.tr, '2')),
                    _buildList(Icons.privacy_tip_outlined, 'Terms & Conditions'.tr, onTap: () => value.onAppPages('Terms & Conditions'.tr, '3')),
                    _buildList(Icons.info_outline, 'About'.tr, onTap: () => value.onAppPages('About us'.tr, '1'), isLast: value.parser.haveLoggedIn() != true),
                    value.parser.haveLoggedIn() == true ? _buildList(Icons.logout, 'Logout'.tr, onTap: () => value.logout(), isLast: true, danger: true) : null,
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionCard(List<Widget?> children) {
    final items = children.whereType<Widget>().toList();
    return Container(
      decoration: ThemeProvider.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(children: items),
    );
  }

  Widget _buildList(IconData icn, String txt, {required VoidCallback onTap, bool isLast = false, bool danger = false}) {
    final tint = danger ? ThemeProvider.redColor : ThemeProvider.appColor;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isLast ? ThemeProvider.transparent : ThemeProvider.borderColor, width: 1))),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(color: tint.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icn, color: tint, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(txt, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontFamily: 'medium', color: danger ? ThemeProvider.redColor : ThemeProvider.textPrimary))),
            Icon(Icons.chevron_right, color: ThemeProvider.textSecondary.withOpacity(0.6), size: 20),
          ],
        ),
      ),
    );
  }
}
