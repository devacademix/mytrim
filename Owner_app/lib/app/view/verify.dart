import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/verify_controller.dart';
import 'package:owner/app/util/theme.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyController>(
      builder: (value) {
        return AbsorbPointer(
          absorbing: value.isLogin.value == false ? false : true,
          child: Stack(
            children: [
              Center(child: Container(width: double.infinity, decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/p7.jpg'))))),
              Scaffold(
                backgroundColor: ThemeProvider.transparent,
                appBar: AppBar(backgroundColor: ThemeProvider.transparent, elevation: 0, iconTheme: const IconThemeData(color: ThemeProvider.whiteColor), titleSpacing: 0),
                bottomNavigationBar: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    decoration: BoxDecoration(
                      color: ThemeProvider.whiteColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                      boxShadow: ThemeProvider.cardShadow,
                    ),
                    child: value.divNumber == 1
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Forgot Password ?'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 20, fontFamily: 'bold')),
                              const SizedBox(height: 6),
                              Text('We will send you an OTP to reset your password'.tr, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13)),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.emailReset,
                                  style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                  decoration: fieldDecoration(hint: 'Email ID'.tr, icon: Icons.mail_outline),
                                ),
                              ),
                              const SizedBox(height: 20),
                              value.isLogin.value == false
                                  ? InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () => value.sendMail(),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                                        decoration: contentButtonStyle(),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Text('Send OTP'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold', letterSpacing: 0.5))],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                                      decoration: contentButtonStyle(),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: ThemeProvider.whiteColor, strokeWidth: 2.4)),
                                        ],
                                      ),
                                    ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gereate Password'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 20, fontFamily: 'bold')),
                              const SizedBox(height: 6),
                              Text('Choose a new password for your account'.tr, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13)),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.passwordReset,
                                  textInputAction: TextInputAction.done,
                                  obscureText: value.passwordVisible.value == true ? false : true,
                                  style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                  decoration: fieldDecoration(
                                    hint: 'New Password'.tr,
                                    icon: Icons.lock_outline,
                                    suffixIcon: InkWell(
                                      onTap: () => value.togglePassword(),
                                      child: Icon(value.passwordVisible.value == false ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.mutedTextColor, size: 20),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.confirmPasswordReset,
                                  textInputAction: TextInputAction.done,
                                  obscureText: value.passwordVisible.value == true ? false : true,
                                  style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                  decoration: fieldDecoration(
                                    hint: 'Confirm Password'.tr,
                                    icon: Icons.lock_outline,
                                    suffixIcon: InkWell(
                                      onTap: () => value.togglePassword(),
                                      child: Icon(value.passwordVisible.value == false ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.mutedTextColor, size: 20),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              value.isLogin.value == false
                                  ? InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () => value.updatePassword(),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                                        decoration: contentButtonStyle(),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Text('Update Password'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold', letterSpacing: 0.5))],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                                      decoration: contentButtonStyle(),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: ThemeProvider.whiteColor, strokeWidth: 2.4))],
                                      ),
                                    ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

InputDecoration fieldDecoration({required String hint, required IconData icon, Widget? suffixIcon}) {
  return InputDecoration(
    filled: true,
    fillColor: ThemeProvider.surfaceTint,
    hintText: hint,
    hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 13),
    prefixIcon: Icon(icon, color: ThemeProvider.mutedTextColor, size: 20),
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.6)),
  );
}

BoxDecoration contentButtonStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(16.0),
    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
    boxShadow: [BoxShadow(color: ThemeProvider.appColor.withOpacity(0.30), blurRadius: 16, offset: const Offset(0, 8))],
  );
}
