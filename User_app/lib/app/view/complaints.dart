import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/complaints_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComplaintsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text('Complaints'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor)),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : AbsorbPointer(
                  absorbing: value.isLogin.value == false ? false : true,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ThemeProvider.cardDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SelectorRow(label: 'Issue With'.tr, value: value.issueWithText, onTap: () => value.onIssueModal()),
                                if (value.issueWith == '1' || value.issueWith == '2' || value.issueWith == '6') ...[
                                  const SizedBox(height: 12),
                                  _SelectorRow(label: 'Freelancer'.tr, value: value.freelancerName != '' ? value.freelancerName : 'Select Freelancer'.tr, onTap: null),
                                ],
                                if (value.issueWith == '4') ...[
                                  const SizedBox(height: 12),
                                  _SelectorRow(label: 'Select product'.tr, value: value.productName != '' ? value.productName : 'Select product'.tr, onTap: () => value.onProductModal()),
                                ],
                                if (value.issueWith == '6') ...[
                                  const SizedBox(height: 12),
                                  _SelectorRow(label: 'Select service'.tr, value: value.serviceName != '' ? value.serviceName : 'Select service'.tr, onTap: () => value.onServiceModal()),
                                ],
                                if (value.issueWith == '9') ...[
                                  const SizedBox(height: 12),
                                  _SelectorRow(label: 'Select package'.tr, value: value.serviceName != '' ? value.serviceName : 'Select package'.tr, onTap: () => value.onPackageModal()),
                                ],
                                const SizedBox(height: 12),
                                _SelectorRow(label: 'Select Reason'.tr, value: value.selectedReason != '' ? value.selectedReason : 'Select Reason'.tr, onTap: () => value.onReasonModal()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ThemeProvider.cardDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Title'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'medium', color: ThemeProvider.textSecondary)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: value.title,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                                  decoration: InputDecoration(
                                    hintText: 'Brief of your issue'.tr,
                                    hintStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13),
                                    filled: true,
                                    fillColor: ThemeProvider.surfaceTint,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ThemeProvider.borderColor)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text('Comments'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'medium', color: ThemeProvider.textSecondary)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: value.comments,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.text,
                                  maxLines: 4,
                                  style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                                  decoration: InputDecoration(
                                    hintText: 'Write something on issue'.tr,
                                    hintStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13),
                                    filled: true,
                                    fillColor: ThemeProvider.surfaceTint,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ThemeProvider.borderColor)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.4)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text('Attachments'.tr, style: const TextStyle(fontSize: 13, fontFamily: 'bold', color: ThemeProvider.textPrimary)),
                          const SizedBox(height: 10),
                          GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            childAspectRatio: 110 / 100,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              value.savedImages.length,
                              (index) {
                                return value.savedImages[index] == '' && index == 0
                                    ? InkWell(
                                        borderRadius: BorderRadius.circular(14),
                                        onTap: () => value.onImageModal(),
                                        child: Container(
                                          width: double.infinity,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.whiteColor,
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: ThemeProvider.borderColor, width: 1.2),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.cloud_upload_outlined, color: ThemeProvider.appColor),
                                                const SizedBox(height: 8),
                                                Text('Upload Image'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 100,
                                          child: FadeInImage(
                                            image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.savedImages[index]}'),
                                            placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 100, width: double.infinity);
                                            },
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 24.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                onTap: () {
                                  if (value.complaintsOn == 1) {
                                    value.onSubmit();
                                  } else {
                                    value.onSave();
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), color: ThemeProvider.appColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      value.isLogin.value == true
                                          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4))
                                          : Text('Submit'.tr, style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'bold')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _SelectorRow extends StatelessWidget {
  const _SelectorRow({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(12), border: Border.all(color: ThemeProvider.borderColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, textAlign: TextAlign.start, style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary)),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(value, textAlign: TextAlign.start, style: const TextStyle(fontSize: 13, fontFamily: 'medium', color: ThemeProvider.textPrimary))),
                if (onTap != null) const Icon(Icons.expand_more, color: ThemeProvider.textSecondary, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
