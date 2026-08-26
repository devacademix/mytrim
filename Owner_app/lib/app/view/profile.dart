import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/profile_controller.dart';
import 'package:owner/app/util/theme.dart';
import 'package:owner/app/env.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: ThemeProvider.surfaceTint,
                floating: true,
                pinned: true,
                toolbarHeight: 300,
                snap: false,
                elevation: 0,
                forceElevated: true,
                iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Column(
                  children: [
                    Container(
                      height: 195,
                      margin: const EdgeInsets.only(bottom: 45),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 170,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
                              image: value.parser.getBackground() == 'NA' ? const DecorationImage(image: AssetImage('assets/images/h4.jpg'), fit: BoxFit.cover) : null,
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  if (value.parser.getBackground() != 'NA')
                                    FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.parser.getBackground().toString()}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/images/notfound.png', fit: BoxFit.cover),
                                      fit: BoxFit.cover,
                                    ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [ThemeProvider.blackColor.withOpacity(0.0), ThemeProvider.blackColor.withOpacity(0.45)],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -35,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: ThemeProvider.whiteColor, shape: BoxShape.circle, boxShadow: ThemeProvider.cardShadow),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(38),
                                  child: FadeInImage(
                                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.parser.getCover().toString()}'),
                                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                    imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 40, width: 40),
                                    fit: BoxFit.cover,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(value.parser.getName(), style: const TextStyle(fontFamily: 'bold', fontSize: 16, color: ThemeProvider.blackColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.star_rounded, size: 16, color: value.parser.getRating() >= 1 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor)),
                            WidgetSpan(child: Icon(Icons.star_rounded, size: 16, color: value.parser.getRating() >= 2 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor)),
                            WidgetSpan(child: Icon(Icons.star_rounded, size: 16, color: value.parser.getRating() >= 3 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor)),
                            WidgetSpan(child: Icon(Icons.star_rounded, size: 16, color: value.parser.getRating() >= 4 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor)),
                            WidgetSpan(child: Icon(Icons.star_rounded, size: 16, color: value.parser.getRating() >= 5 ? ThemeProvider.orangeColor : ThemeProvider.dividerColor)),
                            TextSpan(text: '  (${value.parser.getTotalRating()}${' Reviews) '.tr}', style: const TextStyle(fontSize: 12, color: ThemeProvider.mutedTextColor)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(44),
                  child: Container(
                    color: ThemeProvider.surfaceTint,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Your Profile'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 13, color: ThemeProvider.mutedTextColor)),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                      child: Column(
                        children: [
                          _SettingsCard(
                            children: [
                              _SettingsTile(icon: Icons.edit_outlined, label: 'Edit Profile'.tr, onTap: value.onEditProfile),
                              _SettingsTile(icon: Icons.image_outlined, label: 'Gallary'.tr, onTap: value.onGallary),
                              _SettingsTile(icon: Icons.chat_outlined, label: 'Chats'.tr, onTap: value.onInbox),
                              _SettingsTile(icon: Icons.rate_review_outlined, label: 'Review'.tr, onTap: value.onReview),
                              _SettingsTile(icon: Icons.access_time, label: 'Slots'.tr, onTap: value.onSlot),
                              _SettingsTile(icon: Icons.design_services_outlined, label: 'Services'.tr, onTap: value.onServices),
                              if (value.type == true) _SettingsTile(icon: Icons.style_outlined, label: 'Stylist'.tr, onTap: value.onStylist),
                              _SettingsTile(icon: Icons.list_alt, label: 'Products'.tr, onTap: value.onProducts),
                              _SettingsTile(icon: Icons.receipt_long_outlined, label: 'Packages'.tr, onTap: value.onPackages),
                              _SettingsTile(icon: Icons.history, label: 'History'.tr, onTap: value.onHistory),
                              _SettingsTile(icon: Icons.language, label: 'Languages'.tr, onTap: value.onLanguages),
                              _SettingsTile(icon: Icons.contact_page_outlined, label: 'Contact Us'.tr, onTap: value.onContactUs, isLast: true),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _SettingsCard(
                            children: [
                              _SettingsTile(icon: Icons.flag_outlined, label: 'Frequently Asked Questions'.tr, onTap: () => value.onAppPages('Frequently Asked Questions'.tr, '5')),
                              _SettingsTile(icon: Icons.help_outline, label: 'Help'.tr, onTap: () => value.onAppPages('Help'.tr, '6')),
                              _SettingsTile(icon: Icons.security_outlined, label: 'Privacy Policy'.tr, onTap: () => value.onAppPages('Privacy Policy'.tr, '2')),
                              _SettingsTile(icon: Icons.privacy_tip_outlined, label: 'Terms & Conditions'.tr, onTap: () => value.onAppPages('Terms & Conditions'.tr, '3')),
                              _SettingsTile(icon: Icons.info_outline, label: 'About'.tr, onTap: () => value.onAppPages('About us'.tr, '1')),
                              _SettingsTile(icon: Icons.logout, label: 'Logout'.tr, onTap: value.onLogout, isLast: true, isDestructive: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeProvider.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.label, required this.onTap, this.isLast = false, this.isDestructive = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFDC2626) : ThemeProvider.appColor;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isLast ? ThemeProvider.transparent : ThemeProvider.dividerColor))),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontFamily: 'medium', color: isDestructive ? color : ThemeProvider.blackColor)),
            ),
            Icon(Icons.chevron_right, size: 20, color: ThemeProvider.subtleTextColor),
          ],
        ),
      ),
    );
  }
}
