import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/controller/reset_password_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/env.dart';

class SideMenuScreen extends StatefulWidget {
  const SideMenuScreen({super.key});

  @override
  State<SideMenuScreen> createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(builder: (value) {
      return Drawer(
        backgroundColor: ThemeProvider.surfaceTint,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            value.parser.haveLoggedIn()
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
                    decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ThemeProvider.appColor, ThemeProvider.appColorDark])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(border: Border.all(color: ThemeProvider.whiteColor.withOpacity(0.9), width: 2), shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: FadeInImage(
                              height: 64,
                              width: 64,
                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 64, width: 64);
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('${value.firstName} ${value.lastName}', style: const TextStyle(fontFamily: 'semibold', fontSize: 16, color: ThemeProvider.whiteColor)),
                        const SizedBox(height: 3),
                        Text(value.email, style: TextStyle(color: ThemeProvider.whiteColor.withOpacity(0.78), fontSize: 12, fontFamily: 'regular')),
                      ],
                    ),
                  )
                : const SizedBox(height: 44),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Container(
                decoration: ThemeProvider.cardDecoration(),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: _trim([
                    if (!value.parser.haveLoggedIn())
                      _tile(context, icon: Icons.login_outlined, label: 'Sign In / Sign Up'.tr, onTap: () => value.onLogin()),
                    if (value.parser.haveLoggedIn())
                      _tile(context, icon: Icons.receipt_outlined, label: 'Appointment'.tr, onTap: () => Get.toNamed(AppRouter.bookingRoutes)),
                    if (value.parser.haveLoggedIn())
                      _tile(context, icon: Icons.location_on_outlined, label: 'Address'.tr, onTap: () => Get.toNamed(AppRouter.addressRoutes)),
                    if (value.parser.haveLoggedIn())
                      _tile(context, icon: Icons.account_balance_wallet_outlined, label: 'Wallet'.tr, onTap: () => Get.toNamed(AppRouter.walletRoutes)),
                    if (value.parser.haveLoggedIn())
                      _tile(context, icon: Icons.savings_outlined, label: 'Refer & Earn'.tr, onTap: () => Get.toNamed(AppRouter.referAndEarnRoutes)),
                    _tile(
                      context,
                      icon: Icons.code_rounded,
                      label: 'Change Password'.tr,
                      onTap: () {
                        Get.delete<ResetPasswordController>(force: true);
                        Get.toNamed(AppRouter.getResetPasswordRoute());
                      },
                    ),
                    _tile(context, icon: Icons.language_outlined, label: 'Languages'.tr, onTap: () => Get.toNamed(AppRouter.languagesRoutes)),
                    if (value.parser.haveLoggedIn())
                      _tile(context, icon: Icons.message_outlined, label: 'Chats'.tr, onTap: () => Get.toNamed(AppRouter.accountChatRoutes)),
                    _tile(context, icon: Icons.contact_page_outlined, label: 'Contact Us'.tr, onTap: () => Get.toNamed(AppRouter.contactUsRoutes), isLast: true),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Container(
                decoration: ThemeProvider.cardDecoration(),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: _trim([
                    _tile(context, icon: Icons.flag_outlined, label: 'Frequently Asked Questions'.tr, onTap: () => value.onAppPages('Frequently Asked Questions'.tr, '5')),
                    _tile(context, icon: Icons.help_outline, label: 'Help'.tr, onTap: () => value.onAppPages('Help'.tr, '6')),
                    _tile(context, icon: Icons.security_outlined, label: 'Privacy Policy'.tr, onTap: () => value.onAppPages('Privacy Policy'.tr, '2')),
                    _tile(context, icon: Icons.privacy_tip_outlined, label: 'Terms & Conditions'.tr, onTap: () => value.onAppPages('Terms & Conditions'.tr, '3')),
                    _tile(context, icon: Icons.info_outline, label: 'About'.tr, onTap: () => value.onAppPages('About us'.tr, '1'), isLast: !value.parser.haveLoggedIn()),
                    if (value.parser.haveLoggedIn())
                      _tile(context, icon: Icons.logout, label: 'Logout'.tr, onTap: () => Get.toNamed(AppRouter.login), isLast: true, danger: true),
                  ]),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _trim(List<Widget?> children) => children.whereType<Widget>().toList();

  Widget _tile(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap, bool isLast = false, bool danger = false}) {
    final tint = danger ? ThemeProvider.redColor : ThemeProvider.appColor;
    return InkWell(
      onTap: () {
        Scaffold.of(context).openEndDrawer();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isLast ? ThemeProvider.transparent : ThemeProvider.borderColor, width: 1))),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: tint.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: tint, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.5, fontFamily: 'medium', color: danger ? ThemeProvider.redColor : ThemeProvider.textPrimary))),
            Icon(Icons.chevron_right, color: ThemeProvider.textSecondary.withOpacity(0.6), size: 18),
          ],
        ),
      ),
    );
  }
}
