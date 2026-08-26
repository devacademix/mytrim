import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Widget _socialButton({required String label, required IconData icon, required Color background, required VoidCallback onTap}) {
    return SizedBox(
      height: 52,
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: background,
          foregroundColor: ThemeProvider.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        onPressed: onTap,
        icon: const Icon(Icons.lock_outline, color: ThemeProvider.whiteColor, size: 20),
        label: Text(label, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.blackColor,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const Image(image: AssetImage('assets/images/welcome.jpg'), fit: BoxFit.cover, height: double.infinity, width: double.infinity, alignment: Alignment.center),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ThemeProvider.blackColor.withOpacity(0.0), ThemeProvider.blackColor.withOpacity(0.75)],
                stops: const [0.4, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            child: Column(
              children: [
                const Image(image: AssetImage('assets/images/logo_white.png'), fit: BoxFit.cover, height: 48, width: 48, alignment: Alignment.center),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    'Book an Appointment for Salon, Spa & Barber.'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 20, height: 1.3),
                  ),
                ),
                const SizedBox(height: 20),
                _socialButton(label: 'Connect with Google'.tr, icon: Icons.lock_outline, background: ThemeProvider.secondaryAppColor, onTap: () => {}),
                const SizedBox(height: 12),
                _socialButton(label: 'Connect with Facebook'.tr, icon: Icons.lock_outline, background: ThemeProvider.appColor, onTap: () => {}),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => Get.toNamed(AppRouter.getLoginRoute()),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account?'.tr,
                      style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 14, fontFamily: 'regular'),
                      children: <TextSpan>[TextSpan(text: ' Sign In'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.whiteColor))],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
