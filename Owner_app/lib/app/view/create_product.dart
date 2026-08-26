import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/controller/create_products_controller.dart';
import 'package:owner/app/util/theme.dart';

class CreateProductsScreen extends StatefulWidget {
  const CreateProductsScreen({super.key});

  @override
  State<CreateProductsScreen> createState() => _CreateProductsScreenState();
}

InputDecoration _fieldDecoration(String hint, {bool enabled = true}) {
  return InputDecoration(
    filled: true,
    enabled: enabled,
    fillColor: enabled ? ThemeProvider.surfaceTint : ThemeProvider.dividerColor.withOpacity(0.4),
    hintText: hint,
    hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.dividerColor)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: ThemeProvider.appColor, width: 1.5)),
  );
}

BoxDecoration _pickerDecoration() {
  return BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.dividerColor));
}

Widget _sectionLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 4),
    child: Text(text, style: const TextStyle(fontFamily: 'bold', fontSize: 12, color: ThemeProvider.subtleTextColor)),
  );
}

class _CreateProductsScreenState extends State<CreateProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateProductsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text(value.type == 'create' ? 'Create Products'.tr : 'Update Products'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == true
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) => CupertinoActionSheet(
                                  title: Text('Choose From'.tr),
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        value.selectFromGallery('camera');
                                      },
                                      child: Text('Camera'.tr),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        value.selectFromGallery('gallery');
                                      },
                                      child: Text('Gallery'.tr),
                                    ),
                                    CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'.tr),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ThemeProvider.dividerColor, width: 1), boxShadow: ThemeProvider.cardShadow),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(70),
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(60),
                                      child: FadeInImage(
                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 60, width: 60);
                                        },
                                        fit: BoxFit.cover,
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor),
                                    child: const Icon(Icons.camera_alt, size: 14, color: ThemeProvider.whiteColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _sectionLabel('Category'.tr),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: _pickerDecoration(),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => value.onShopCategories(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Categories'.tr, style: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 11)),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        value.selectedCateName == ''
                                            ? Text('Select Categories'.tr, style: const TextStyle(fontSize: 15, color: ThemeProvider.subtleTextColor))
                                            : Text(value.selectedCateName, style: const TextStyle(fontSize: 15, color: ThemeProvider.blackColor)),
                                        const Icon(Icons.expand_more, color: ThemeProvider.subtleTextColor),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: _pickerDecoration(),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => value.onShopSubCategories(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Select Subcategories'.tr, style: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 11)),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        value.selectedSubName == ''
                                            ? Text('Sub Categories'.tr, style: const TextStyle(fontSize: 15, color: ThemeProvider.subtleTextColor))
                                            : Text(value.selectedSubName, style: const TextStyle(fontSize: 15, color: ThemeProvider.blackColor)),
                                        const Icon(Icons.expand_more, color: ThemeProvider.subtleTextColor),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        _sectionLabel('Details'.tr),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: value.productNameTextEditor,
                              style: const TextStyle(fontSize: 14),
                              decoration: _fieldDecoration('Products Name'.tr),
                            ),
                          ),
                        ),
                        _sectionLabel('Pricing'.tr),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: value.productsPriceTextEditor,
                              onChanged: (String txt) => value.onRealPrice(txt),
                              style: const TextStyle(fontSize: 14),
                              decoration: _fieldDecoration('Products Price'.tr),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: value.discountTextEditor,
                              onChanged: (String txt) => value.onDiscountPrice(txt),
                              style: const TextStyle(fontSize: 14),
                              decoration: _fieldDecoration('Discount %'.tr),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: value.sellPriceTextEditor,
                              enabled: false,
                              style: const TextStyle(fontSize: 14),
                              decoration: _fieldDecoration('Sell Price'.tr, enabled: false),
                            ),
                          ),
                        ),
                        _sectionLabel('Offer & Stock'.tr),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: _pickerDecoration(),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoActionSheet(
                                    title: Text('Choose From'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.blackColor, fontSize: 14)),
                                    actions: <CupertinoActionSheetAction>[
                                      CupertinoActionSheetAction(
                                        child: Text('Available'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 15)),
                                        onPressed: () {
                                          value.updateOfferStatus(1);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text('Hide'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 15)),
                                        onPressed: () {
                                          value.updateOfferStatus(0);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.redColor, fontSize: 14)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('in Offers'.tr, style: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 11)),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(value.selectedOfferStatus == 1 ? 'Available'.tr : 'Hide'.tr, style: const TextStyle(fontSize: 15, color: ThemeProvider.blackColor)),
                                        const Icon(Icons.expand_more, color: ThemeProvider.subtleTextColor),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: _pickerDecoration(),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoActionSheet(
                                    title: Text('Choose From'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.blackColor, fontSize: 14)),
                                    actions: <CupertinoActionSheetAction>[
                                      CupertinoActionSheetAction(
                                        child: Text('Available'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 15)),
                                        onPressed: () {
                                          value.updateStackStatus(1);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text('Hide'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 15)),
                                        onPressed: () {
                                          value.updateStackStatus(0);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.redColor, fontSize: 14)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('in Stock'.tr, style: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 11)),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(value.selectedStackStatus == 1 ? 'Available'.tr : 'Hide'.tr, style: const TextStyle(fontSize: 15, color: ThemeProvider.blackColor)),
                                        const Icon(Icons.expand_more, color: ThemeProvider.subtleTextColor),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        _sectionLabel('Visibility'.tr),
                        Container(
                          decoration: ThemeProvider.cardDecoration(radius: 14),
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: Text('in Home'.tr, style: const TextStyle(fontSize: 14)),
                                value: value.inHome,
                                activeColor: ThemeProvider.greenColor,
                                onChanged: (bool status) {
                                  value.updateinHome(status);
                                },
                              ),
                              const Divider(height: 1, color: ThemeProvider.dividerColor),
                              SwitchListTile(
                                title: Text('in Single'.tr, style: const TextStyle(fontSize: 14)),
                                value: value.inSingle,
                                activeColor: ThemeProvider.greenColor,
                                onChanged: (bool status) => value.updateinSingle(status),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(children: [Text('Upload More Image'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor))]),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 6),
                          child: GridView.count(
                            primary: false,
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            shrinkWrap: true,
                            childAspectRatio: 100 / 100,
                            padding: EdgeInsets.zero,
                            children: List.generate(
                              value.gallery.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (BuildContext context) => CupertinoActionSheet(
                                        title: Text('Choose From'.tr),
                                        actions: <CupertinoActionSheetAction>[
                                          CupertinoActionSheetAction(
                                            isDefaultAction: true,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              value.selectFromGalleryOthers('camera', index);
                                            },
                                            child: Text('Camera'.tr),
                                          ),
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              value.selectFromGalleryOthers('gallery', index);
                                            },
                                            child: Text('Gallery'.tr),
                                          ),
                                          CupertinoActionSheetAction(
                                            isDestructiveAction: true,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'.tr),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: ThemeProvider.dividerColor)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(11),
                                      child: FadeInImage(
                                        image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.gallery[index]}'),
                                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _sectionLabel('Unit & Quantity'.tr),
                        Container(
                          decoration: ThemeProvider.cardDecoration(radius: 14),
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: Text('in Gram'.tr, style: const TextStyle(fontSize: 14)),
                                value: value.inGrams,
                                activeColor: ThemeProvider.greenColor,
                                onChanged: (bool status) => value.updateinGrams(status),
                              ),
                              value.inGrams == true
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextField(
                                          controller: value.gramTextEditor,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: _fieldDecoration('Gram Value'.tr),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              const Divider(height: 1, color: ThemeProvider.dividerColor),
                              SwitchListTile(
                                title: Text('in KG'.tr, style: const TextStyle(fontSize: 14)),
                                value: value.inKG,
                                activeColor: ThemeProvider.greenColor,
                                onChanged: (bool status) {
                                  setState(() {
                                    value.updateinKG(status);
                                  });
                                },
                              ),
                              value.inKG == true
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextField(
                                          controller: value.kgTextEditor,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: _fieldDecoration('KG Value'.tr),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              const Divider(height: 1, color: ThemeProvider.dividerColor),
                              SwitchListTile(
                                title: Text('in Liter'.tr, style: const TextStyle(fontSize: 14)),
                                value: value.inLiter,
                                activeColor: ThemeProvider.greenColor,
                                onChanged: (bool status) => value.updateinLiter(status),
                              ),
                              value.inLiter == true
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextField(
                                          controller: value.literTextEditor,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: _fieldDecoration('Liter Value'.tr),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              const Divider(height: 1, color: ThemeProvider.dividerColor),
                              SwitchListTile(
                                title: Text('in PCs'.tr, style: const TextStyle(fontSize: 14)),
                                value: value.inPCs,
                                activeColor: ThemeProvider.greenColor,
                                onChanged: (bool status) => value.updateinPCs(status),
                              ),
                              value.inPCs == true
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextField(
                                          controller: value.pcsTextEditor,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: _fieldDecoration('PCs Value'.tr),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              const Divider(height: 1, color: ThemeProvider.dividerColor),
                              SwitchListTile(
                                title: Text('in ML'.tr, style: const TextStyle(fontSize: 14)),
                                value: value.inML,
                                activeColor: ThemeProvider.greenColor,
                                onChanged: (bool status) => value.updateinML(status),
                              ),
                              value.inML == true
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextField(
                                          controller: value.mlTextEditor,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: _fieldDecoration('ML Value'.tr),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        _sectionLabel('Expiry'.tr),
                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () async => value.openTimePicker(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: _pickerDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.event_outlined, size: 18, color: ThemeProvider.mutedTextColor),
                                    const SizedBox(width: 8),
                                    Text('Expired Date'.tr, style: const TextStyle(fontSize: 14, color: ThemeProvider.blackColor)),
                                  ],
                                ),
                                Text(
                                  '${value.expDate.day}/${value.expDate.month}/${value.expDate.year}',
                                  style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.appColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: value.type == 'create'
                  ? InkWell(
                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                      onTap: () => value.saveProducts(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        decoration: contentButtonStyle(),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('SUBMIT'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 15))]),
                      ),
                    )
                  : InkWell(
                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                      onTap: () => value.updateProduct(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        decoration: const BoxDecoration(color: ThemeProvider.greenColor, borderRadius: BorderRadius.all(Radius.circular(ThemeProvider.chipRadius))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('UPDATE'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 15))],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

contentButtonStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
}
