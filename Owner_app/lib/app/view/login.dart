import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/login_controller.dart';
import 'package:owner/app/util/constance.dart';
import 'package:owner/app/util/theme.dart';
import 'package:country_picker/country_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget getLanguages() {
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 12),
      child: Container(
        decoration: BoxDecoration(color: ThemeProvider.whiteColor.withOpacity(0.9), shape: BoxShape.circle, boxShadow: ThemeProvider.cardShadow),
        child: PopupMenuButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onSelected: (value) {},
          child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.translate, color: ThemeProvider.appColor, size: 20)),
          itemBuilder: (context) => AppConstants.languages
              .map(
                (e) => PopupMenuItem<String>(
                  value: e.languageCode.toString(),
                  onTap: () {
                    var locale = Locale(e.languageCode.toString());
                    Get.updateLocale(locale);
                    Get.find<LoginController>().saveLanguage(e.languageCode);
                  },
                  child: Text(
                    e.languageName.toString(),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (value) {
        return Stack(
          children: [
            Center(child: Container(width: double.infinity, decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/p7.jpg'))))),
            Scaffold(
              backgroundColor: ThemeProvider.transparent,
              extendBodyBehindAppBar: true,
              appBar: AppBar(backgroundColor: ThemeProvider.transparent, elevation: 0, actions: <Widget>[getLanguages()], automaticallyImplyLeading: false),
              bottomNavigationBar: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)), boxShadow: ThemeProvider.cardShadow),
                  child: value.loginVersion == 0
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 22, fontFamily: 'bold')),
                            const SizedBox(height: 6),
                            Text('Login With Your Account'.tr, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13)),
                            const SizedBox(height: 20),
                            _AuthField(controller: value.emailTextEditor, hint: 'Email ID'.tr, icon: Icons.mail_outline),
                            const SizedBox(height: 12),
                            _AuthField(
                              controller: value.passwordTextEditor,
                              hint: 'Password'.tr,
                              icon: Icons.lock_outline,
                              obscureText: value.passwordVisible.value == true ? false : true,
                              suffixIcon: InkWell(
                                onTap: () => value.togglePassword(),
                                child: Icon(value.passwordVisible.value == false ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.mutedTextColor, size: 20),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () => value.onForgot(),
                                child: Text('Forgot Password?'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 13, fontFamily: 'medium')),
                              ),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => value.onLogin(),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                decoration: contentButtonStyle(),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('LOG IN'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold', letterSpacing: 0.5))]),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: InkWell(onTap: () => value.onSignUp(), child: Text("Don't have an Account? Sign Up".tr, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13))),
                            ),
                          ],
                        )
                      : value.loginVersion == 1
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Welcome'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 22, fontFamily: 'bold')),
                                const SizedBox(height: 6),
                                Text('Login With Your Account'.tr, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13)),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    _CountryCodeChip(
                                      countryCode: value.countryCode.toString(),
                                      onTap: () {
                                        showCountryPicker(
                                          context: context,
                                          favorite: <String>['IN'],
                                          showPhoneCode: true,
                                          onSelect: (Country country) => value.updateCountryCode('+${country.phoneCode.toString()}'),
                                          countryListTheme: CountryListThemeData(
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
                                            inputDecoration: InputDecoration(
                                              labelText: 'Search'.tr,
                                              hintText: 'Start typing to search'.tr,
                                              prefixIcon: const Icon(Icons.search),
                                              border: OutlineInputBorder(borderSide: BorderSide(color: const Color(0xFF8C98A8).withOpacity(0.2))),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: value.mobileNo,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: fieldDecoration(hint: 'Mobile Number'.tr, icon: Icons.phone_outlined),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _AuthField(
                                  controller: value.passwordTextEditor,
                                  hint: 'Password'.tr,
                                  icon: Icons.lock_outline,
                                  obscureText: value.passwordVisible.value == true ? false : true,
                                  suffixIcon: InkWell(
                                    onTap: () => value.togglePassword(),
                                    child: Icon(value.passwordVisible.value == false ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.mutedTextColor, size: 20),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(onTap: () => value.onForgot(), child: Text('Forgot Password?'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 13, fontFamily: 'medium'))),
                                ),
                                const SizedBox(height: 20),
                                InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => value.loginWithPhonePassword(),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                                    decoration: contentButtonStyle(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [Text('LOG IN'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold', letterSpacing: 0.5))],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: InkWell(onTap: () => value.onSignUp(), child: Text("Don't have an Account? Sign Up".tr, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13))),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Welcome'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 22, fontFamily: 'bold')),
                                const SizedBox(height: 6),
                                Text('Login With Your Account'.tr, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13)),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    _CountryCodeChip(
                                      countryCode: value.countryCode.toString(),
                                      onTap: () {
                                        showCountryPicker(
                                          context: context,
                                          favorite: <String>['IN'],
                                          showPhoneCode: true,
                                          onSelect: (Country country) => value.updateCountryCode('+${country.phoneCode.toString()}'),
                                          countryListTheme: CountryListThemeData(
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
                                            inputDecoration: InputDecoration(
                                              labelText: 'Search'.tr,
                                              hintText: 'Start typing to search'.tr,
                                              prefixIcon: const Icon(Icons.search),
                                              border: OutlineInputBorder(borderSide: BorderSide(color: const Color(0xFF8C98A8).withOpacity(0.2))),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: value.mobileNo,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
                                        decoration: fieldDecoration(hint: 'Mobile Number'.tr, icon: Icons.phone_outlined),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(onTap: () => value.onForgot(), child: Text('Forgot Password?'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 13, fontFamily: 'medium'))),
                                ),
                                const SizedBox(height: 20),
                                InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => value.loginWithPhoneOTP(),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                                    decoration: contentButtonStyle(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [Text('LOG IN'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold', letterSpacing: 0.5))],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: InkWell(onTap: () => value.onSignUp(), child: Text("Don't have an Account? Sign Up".tr, style: const TextStyle(color: ThemeProvider.mutedTextColor, fontSize: 13))),
                                ),
                              ],
                            ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({required this.controller, required this.hint, required this.icon, this.obscureText = false, this.suffixIcon});

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor),
        decoration: fieldDecoration(hint: hint, icon: icon, suffixIcon: suffixIcon),
      ),
    );
  }
}

class _CountryCodeChip extends StatelessWidget {
  const _CountryCodeChip({required this.countryCode, required this.onTap});

  final String countryCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.dividerColor)),
        child: Center(
          child: Text(countryCode, style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor, fontFamily: 'medium')),
        ),
      ),
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
