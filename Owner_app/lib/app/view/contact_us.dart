import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/contact_us_controller.dart';
import 'package:owner/app/util/theme.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactUsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                onTap: () => value.saveContacts(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  decoration: contentButtonStyle(),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    value.isLogin.value == true
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: ThemeProvider.whiteColor, strokeWidth: 2.2))
                        : Text('Submit'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold'))
                  ]),
                ),
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: ThemeProvider.appColor,
                floating: true,
                pinned: true,
                snap: false,
                elevation: 0,
                forceElevated: true,
                iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
                titleSpacing: 0,
                centerTitle: true,
                title: Text('Contact Us'.tr, style: ThemeProvider.titleStyle),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: ThemeProvider.cardDecoration(),
                        child: Column(
                          children: [
                            _ContactField(controller: value.nameContact, hint: 'Full Name'.tr, icon: Icons.person_outline),
                            const SizedBox(height: 14),
                            _ContactField(controller: value.emailContanct, hint: 'Email Address'.tr, icon: Icons.mail_outline),
                            const SizedBox(height: 14),
                            _ContactField(controller: value.messageContanct, hint: 'Message'.tr, icon: Icons.chat_bubble_outline, maxLines: 5),
                          ],
                        ),
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

class _ContactField extends StatelessWidget {
  const _ContactField({required this.controller, required this.hint, required this.icon, this.maxLines = 1});

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 14),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 62 : 0),
          child: Icon(icon, color: ThemeProvider.appColor, size: 19),
        ),
        filled: true,
        fillColor: ThemeProvider.surfaceTint,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
      ),
    );
  }
}

contentButtonStyle() {
  return BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(100.0)),
    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
    boxShadow: [BoxShadow(color: ThemeProvider.appColor.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
  );
}
