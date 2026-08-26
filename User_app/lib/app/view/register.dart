import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:user/app/controller/register_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = false;

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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ThemeProvider.appColor,
            leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor)),
            title: Text('Create an Account'.tr, style: ThemeProvider.titleStyle),
          ),
          body: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tell us about yourself'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 20, color: ThemeProvider.textPrimary)),
                  const SizedBox(height: 4),
                  Text('A few quick details to set up your booking profile'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 14, color: ThemeProvider.textSecondary)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: value.firstNameTextEditor,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _fieldDecoration('First Name'.tr),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: value.lastNameTextEditor,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _fieldDecoration('Last Name'.tr),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: value.emailTextEditor,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _fieldDecoration('Email Address'.tr),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.borderColor)),
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
                            controller: value.mobileTextEditor,
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
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: value.passwordTextEditor,
                    textInputAction: TextInputAction.next,
                    obscureText: passwordVisible == true ? false : true,
                    decoration: _fieldDecoration(
                      'Password'.tr,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        icon: Icon(passwordVisible == false ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: value.referralCodeTextEditor,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _fieldDecoration('Referral Code (optional)'.tr),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'By continuing, you agree to our '.tr,
                        style: const TextStyle(fontSize: 12, fontFamily: 'regular', color: ThemeProvider.textSecondary),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terms of Service'.tr,
                            style: const TextStyle(fontSize: 12, color: ThemeProvider.appColor, fontFamily: 'bold', decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () => value.onAppPages('Terms & Conditions'.tr, '3'),
                          ),
                          TextSpan(
                            text: ' and '.tr,
                            style: const TextStyle(fontSize: 12, fontFamily: 'regular', color: ThemeProvider.textSecondary),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Privacy Policy'.tr,
                                style: const TextStyle(fontSize: 12, color: ThemeProvider.appColor, fontFamily: 'bold', decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () => value.onAppPages('Privacy Policy'.tr, '2'),
                              )
                            ],
                          )
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => value.onRegister(),
                    borderRadius: BorderRadius.circular(14),
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
                        children: [Text('Sign Up'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold'))],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('You have already account ?'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.textSecondary)),
                        const SizedBox(width: 8),
                        InkWell(onTap: () => Get.back(), child: Text('Log in'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.appColor))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
