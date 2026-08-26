import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/app/controller/web_payment_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPayment extends StatefulWidget {
  const WebPayment({super.key});

  @override
  State<WebPayment> createState() => _WebPaymentState();
}

class _WebPaymentState extends State<WebPayment> {
  bool isLoading = true;
  bool recallAPI = true;
  bool isDesktopPlatform = false;
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();

    if (GetPlatform.isDesktop) {
      setState(() {
        isDesktopPlatform = true;
        isLoading = false;
      });
      return;
    }

    try {
      final WebViewController controller = WebViewController();
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {
              checkCallback(url);
            },
            onPageFinished: (String url) {
              checkCallback(url);
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              checkCallback(request.url);
              return NavigationDecision.navigate;
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..loadRequest(Uri.parse(Get.find<WebPaymentController>().paymentURL));

      _controller = controller;
    } catch (e) {
      debugPrint('WebView init fallback on Desktop: $e');
      if (mounted) {
        setState(() {
          isDesktopPlatform = true;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebPaymentController>(
      builder: (value) {
        if (isDesktopPlatform || _controller == null) {
          final url = Get.find<WebPaymentController>().paymentURL;
          return Scaffold(
            backgroundColor: ThemeProvider.surfaceTint,
            appBar: AppBar(
              backgroundColor: ThemeProvider.appColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
              title: Text('Web Payment'.tr, style: ThemeProvider.titleStyle),
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(24),
                  decoration: ThemeProvider.cardDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.payment_outlined, size: 64, color: ThemeProvider.appColor),
                      const SizedBox(height: 16),
                      Text('Secure Payment Checkout'.tr, style: const TextStyle(fontSize: 20, fontFamily: 'bold', color: ThemeProvider.textPrimary)),
                      const SizedBox(height: 12),
                      Text(
                        'WebView is supported on Mobile devices (Android/iOS).\nFor Windows Desktop testing, launch the payment URL in browser or simulate payment completion.'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: ThemeProvider.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(Icons.open_in_browser, size: 18),
                          label: Text('Open Payment Link in Browser'.tr, style: const TextStyle(fontFamily: 'medium')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeProvider.appColor,
                            foregroundColor: ThemeProvider.whiteColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Get.find<WebPaymentController>().createOrderRequest('DESKTOP_PAYMENT_SUCCESS');
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 18, color: ThemeProvider.greenColor),
                          label: Text('Simulate Successful Order'.tr, style: const TextStyle(fontFamily: 'medium', color: ThemeProvider.greenColor)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: ThemeProvider.greenColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return SafeArea(
          child: Scaffold(
            backgroundColor: ThemeProvider.whiteColor,
            body: Stack(
              children: <Widget>[
                WebViewWidget(controller: _controller!),
                isLoading
                    ? Container(
                        color: ThemeProvider.whiteColor,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: ThemeProvider.cardDecoration(radius: ThemeProvider.chipRadius),
                                child: const CircularProgressIndicator(color: ThemeProvider.appColor, strokeWidth: 2.6),
                              ),
                              const SizedBox(height: 16),
                              Text('Loading secure checkout'.tr, style: const TextStyle(fontFamily: 'medium', fontSize: 13, color: ThemeProvider.textSecondary)),
                            ],
                          ),
                        ),
                      )
                    : const Stack(),
              ],
            ),
          ),
        );
      },
    );
  }

  void checkCallback(String callback) {
    debugPrint(callback);
    if (recallAPI == true) {
      if (callback.contains('success_payments') ||
          callback.contains('failed_payments') ||
          callback.contains('status=authorized') ||
          callback.contains('status=failed') ||
          callback.contains('success') ||
          callback.contains('close') ||
          callback.contains('redirect_callback')) {
        setState(() {
          recallAPI = false;
        });
        FocusScope.of(context).requestFocus(FocusNode());
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        if (callback.contains('success_payments') || callback.contains('status=authorized') || callback.contains('success') || callback.contains('close') || callback.contains('redirect_callback')) {
          if (Get.find<WebPaymentController>().payMethod == 'paypal') {
            final successCallback = Uri.parse(callback);
            final payKey = successCallback.queryParameters['pay_id'];
            Get.find<WebPaymentController>().createOrderRequest(payKey.toString());
          } else if (Get.find<WebPaymentController>().payMethod == 'paytm') {
            final successCallback = Uri.parse(callback);
            final payId = successCallback.queryParameters['id'];
            final taxId = successCallback.queryParameters['txt_id'];
            var payData = {'key': payId, 'txtId': taxId};
            Get.find<WebPaymentController>().createOrderRequest(jsonEncode(payData));
          } else if (Get.find<WebPaymentController>().payMethod == 'razorpay') {
            final successCallback = Uri.parse(callback).path;
            debugPrint(successCallback);
            if (successCallback.toString().split('/').length >= 5 && successCallback.toString().split('/')[3].startsWith('pay_')) {
              final paymentId = successCallback.toString().split('/')[3];
              Get.find<WebPaymentController>().verifyRazorpayPurchase(paymentId.toString());
            }
          } else if (Get.find<WebPaymentController>().payMethod == 'instamojo') {
            final successCallback = Uri.parse(callback);
            final payId = successCallback.queryParameters['payment_id'];
            Get.find<WebPaymentController>().createOrderRequest(payId.toString());
          } else if (Get.find<WebPaymentController>().payMethod == 'paystack') {
            final successCallback = Uri.parse(callback);
            final payId = successCallback.queryParameters['id'];
            Get.find<WebPaymentController>().createOrderRequest(payId.toString());
          } else if (Get.find<WebPaymentController>().payMethod == 'flutterwave') {
            final successCallback = Uri.parse(callback);
            final taxRef = successCallback.queryParameters['tx_ref'];
            final orderId = successCallback.queryParameters['transaction_id'];
            var payData = {'orderId': orderId, 'txtId': taxRef};
            Get.find<WebPaymentController>().createOrderRequest(jsonEncode(payData));
          } else if (Get.find<WebPaymentController>().payMethod == 'stripe') {
            final successCallback = Uri.parse(callback);
            final sessionId = successCallback.queryParameters['session_id'];
            var payData = {'key': sessionId};
            Get.find<WebPaymentController>().createOrderRequest(jsonEncode(payData));
          }
        }
      }
    }
  }
}
