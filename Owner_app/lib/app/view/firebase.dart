import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/util/constance.dart';
import 'package:owner/app/util/theme.dart';
import 'package:owner/app/controller/firebase_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FirebaseVerificationScreen extends StatefulWidget {
  const FirebaseVerificationScreen({super.key});

  @override
  State<FirebaseVerificationScreen> createState() => _FirebaseVerificationScreenState();
}

class _FirebaseVerificationScreenState extends State<FirebaseVerificationScreen> {
  bool isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final WebViewController controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(ThemeProvider.surfaceTint)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success_verified')) {
              Get.find<FirebaseController>().onLogin();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel('Toaster', onMessageReceived: (JavaScriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
      })
      ..loadRequest(Uri.parse('${Get.find<FirebaseController>().apiURL}${AppConstants.openFirebaseVerification}mobile=${Get.find<FirebaseController>().countryCode}${Get.find<FirebaseController>().phoneNumber}'));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.surfaceTint,
        appBar: AppBar(
          backgroundColor: ThemeProvider.appColor,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
          title: Text('Verify your phone number'.tr, style: ThemeProvider.titleStyle),
        ),
        body: Stack(
          children: <Widget>[
            WebViewWidget(controller: _controller),
            if (isLoading)
              Container(
                color: ThemeProvider.surfaceTint,
                child: const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor)),
              ),
          ],
        ),
      );
    });
  }
}
