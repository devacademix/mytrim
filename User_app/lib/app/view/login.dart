import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/login_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  InputDecoration _fieldDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14, fontFamily: 'regular'),
      filled: true,
      fillColor: ThemeProvider.surfaceTint,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.5)),
    );
  }

  BoxDecoration get _fieldBoxDecoration => BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.borderColor));

  Widget _primaryButton(String label, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: ThemeProvider.appColor,
          boxShadow: [BoxShadow(color: ThemeProvider.appColor.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 8))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(label, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold'))],
        ),
      ),
    );
  }

  Widget _forgotPasswordRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => Get.toNamed(AppRouter.getResetPasswordRoute()),
          child: Text('Forgot Password ?'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'semibold', fontSize: 13)),
        ),
      ],
    );
  }

  Widget _signUpRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have account ?".tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.textSecondary)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => Get.toNamed(AppRouter.getRegisterRoute()),
            child: Text('Sign Up'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.appColor)),
          ),
        ],
      ),
    );
  }

  Widget _countryCodeMobileField(LoginController value) {
    return Container(
      decoration: _fieldBoxDecoration,
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(minWidth: 110),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(border: Border(right: BorderSide(color: ThemeProvider.borderColor))),
            child: CountryCodePicker(
              onChanged: (e) => value.updateCountryCode(e.dialCode.toString()),
              initialSelection: 'IN',
              favorite: const ['+91', 'IN'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14, fontFamily: 'medium'),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: value.mobileNo,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                labelText: 'Mobile Number'.tr,
                labelStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          body: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 280,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: ThemeProvider.appColor, image: DecorationImage(fit: BoxFit.fitHeight, image: AssetImage('assets/images/login.jpg'))),
                    ),
                    Positioned(
                      bottom: -1,
                      height: 36,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: const BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Back'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 24, color: ThemeProvider.textPrimary)),
                      const SizedBox(height: 6),
                      Text('Log in to continue booking your favourite salon services'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textSecondary, height: 1.4)),
                      const SizedBox(height: 24),
                      value.loginVersion == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(controller: value.emailTextEditor, decoration: _fieldDecoration('Email Address'.tr)),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: value.passwordTextEditor,
                                  obscureText: value.passwordVisible == true ? false : true,
                                  decoration: _fieldDecoration(
                                    'Password'.tr,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          value.passwordVisible = !value.passwordVisible;
                                        });
                                      },
                                      icon: Icon(value.passwordVisible == false ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.textSecondary),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _forgotPasswordRow(),
                                const SizedBox(height: 20),
                                _primaryButton('Log In'.tr, () => value.onLogin()),
                                _signUpRow(),
                              ],
                            )
                          : value.loginVersion == 1
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _countryCodeMobileField(value),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: value.passwordTextEditor,
                                      obscureText: value.passwordVisible == true ? false : true,
                                      decoration: _fieldDecoration(
                                        'Password'.tr,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              value.passwordVisible = !value.passwordVisible;
                                            });
                                          },
                                          icon: Icon(value.passwordVisible == false ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.textSecondary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _forgotPasswordRow(),
                                    const SizedBox(height: 20),
                                    _primaryButton('Log In'.tr, () => value.loginWithPhonePassword()),
                                    _signUpRow(),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _countryCodeMobileField(value),
                                    const SizedBox(height: 12),
                                    _forgotPasswordRow(),
                                    const SizedBox(height: 20),
                                    _primaryButton('Log In'.tr, () => value.loginWithPhoneOTP()),
                                    _signUpRow(),
                                  ],
                                ),
                    ],
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
