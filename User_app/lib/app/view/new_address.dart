import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/new_address_controller.dart';
import 'package:user/app/util/theme.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({super.key});

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14, fontFamily: 'regular'),
      border: InputBorder.none,
      isDense: true,
    );
  }

  BoxDecoration get _fieldBox => BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.borderColor, width: 1));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewAddressController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Add New Address'.tr, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: _fieldBox,
                          child: TextField(
                            controller: value.addressTextEditor,
                            style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                            decoration: _fieldDecoration('Address'.tr),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: _fieldBox,
                          child: TextField(
                            controller: value.houseTextEditor,
                            style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                            decoration: _fieldDecoration('House / Flat No.'.tr),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: _fieldBox,
                          child: TextField(
                            controller: value.landmarkTextEditor,
                            style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                            decoration: _fieldDecoration('Landmark'.tr),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: _fieldBox,
                          child: TextField(
                            controller: value.pincodeTextEditor,
                            style: const TextStyle(fontSize: 14, color: ThemeProvider.textPrimary),
                            decoration: _fieldDecoration('Pincode'.tr),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text('Save Address As'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.textPrimary)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _typeChip(icon: Icons.home_outlined, label: 'Home'.tr, selected: value.title == 0, onTap: () => value.onFilter(0))),
                            const SizedBox(width: 10),
                            Expanded(child: _typeChip(icon: Icons.work_outline, label: 'Work'.tr, selected: value.title == 1, onTap: () => value.onFilter(1))),
                            const SizedBox(width: 10),
                            Expanded(child: _typeChip(icon: Icons.home_work_outlined, label: 'Other'.tr, selected: value.title == 2, onTap: () => value.onFilter(2))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: value.action == 'new'
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                    onTap: () => value.getLatLngFromAddress(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: contentButtonStyle(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Submit'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'semibold'))],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                    onTap: () => value.updateAddress(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), color: ThemeProvider.greenColor),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Update'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'semibold'))]),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _typeChip({required IconData icon, required String label, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? ThemeProvider.appColor.withOpacity(0.08) : ThemeProvider.surfaceTint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? ThemeProvider.appColor : ThemeProvider.borderColor, width: selected ? 1.5 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? ThemeProvider.appColor : ThemeProvider.textSecondary, size: 20),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 12.5, fontFamily: 'medium', color: selected ? ThemeProvider.appColor : ThemeProvider.textPrimary)),
          ],
        ),
      ),
    );
  }
}

contentButtonStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [ThemeProvider.appColor, ThemeProvider.appColorDark]),
  );
}
