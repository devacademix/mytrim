import 'package:flutter/material.dart';
import 'package:user/app/controller/reset_password_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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

  Widget _submitButton({required VoidCallback onTap, required bool isLoading, required String label}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: ThemeProvider.whiteColor,
          backgroundColor: ThemeProvider.appColor,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: ThemeProvider.whiteColor, strokeWidth: 2.4)) : Text(label, style: const TextStyle(fontFamily: 'semibold', fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          appBar: AppBar(backgroundColor: ThemeProvider.appColor, iconTheme: const IconThemeData(color: ThemeProvider.whiteColor), elevation: 0, title: Text('Reset Password'.tr, style: ThemeProvider.titleStyle)),
          body: AbsorbPointer(
            absorbing: value.isLogin.value == false ? false : true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: value.divNumber == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Forgot your password?'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 20, color: ThemeProvider.textPrimary)),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your email address or phone number and we will send a verification code to generate a new password'.tr,
                          style: const TextStyle(fontSize: 14, color: ThemeProvider.textSecondary, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: value.emailReset,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _fieldDecoration('Email Address'.tr),
                        ),
                        const SizedBox(height: 24),
                        _submitButton(onTap: () => value.sendMail(), isLoading: value.isLogin.value == true, label: 'Send OTP'.tr),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Generate New Password'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 20, color: ThemeProvider.textPrimary)),
                        const SizedBox(height: 8),
                        Text('Choose a strong new password to secure your account'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.textSecondary, height: 1.5)),
                        const SizedBox(height: 24),
                        TextField(
                          controller: value.passwordReset,
                          textInputAction: TextInputAction.done,
                          obscureText: value.passwordVisible.value == true ? false : true,
                          decoration: _fieldDecoration(
                            'New Password'.tr,
                            suffixIcon: InkWell(
                              onTap: () => value.togglePassword(),
                              child: Icon(value.passwordVisible.value == false ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.textSecondary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: value.confirmPasswordReset,
                          textInputAction: TextInputAction.done,
                          obscureText: value.passwordVisible.value == true ? false : true,
                          decoration: _fieldDecoration(
                            'Confirm Password'.tr,
                            suffixIcon: InkWell(
                              onTap: () => value.togglePassword(),
                              child: Icon(value.passwordVisible.value == false ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: ThemeProvider.textSecondary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _submitButton(onTap: () => value.updatePassword(), isLoading: value.isLogin.value == true, label: 'Update Password'.tr),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
