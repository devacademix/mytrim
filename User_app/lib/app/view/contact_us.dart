import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/contact_us_controller.dart';
import 'package:user/app/util/theme.dart';

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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20, left: 20, right: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
              onTap: () => value.saveContacts(),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: contentButtonStyle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    value.isLogin.value == true
                        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: ThemeProvider.whiteColor, strokeWidth: 2.4))
                        : Text('Submit'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold')),
                  ],
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
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: ThemeProvider.cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Get in touch'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 17, color: ThemeProvider.textPrimary)),
                            const SizedBox(height: 4),
                            Text('We usually reply within 24 hours'.tr, style: const TextStyle(fontSize: 13, color: ThemeProvider.textSecondary)),
                            const SizedBox(height: 20),
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

contentButtonStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
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
      style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 64 : 0),
          child: Icon(icon, color: ThemeProvider.textSecondary, size: 20),
        ),
        filled: true,
        fillColor: ThemeProvider.surfaceTint,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
      ),
    );
  }
}
