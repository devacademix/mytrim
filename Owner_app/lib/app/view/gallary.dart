import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/gallary_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class GallaryScreen extends StatefulWidget {
  const GallaryScreen({super.key});

  @override
  State<GallaryScreen> createState() => _GallaryScreenState();
}

class _GallaryScreenState extends State<GallaryScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GallaryController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Gallary'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
          ),
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(14.0),
                  child: GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1),
                    itemCount: value.gallery.length,
                    itemBuilder: (context, index) {
                      return value.gallery[index] == ''
                          ? GestureDetector(
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
                                          value.selectFromGalleryOthers('camera');
                                        },
                                        child: Text('Camera'.tr),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          value.selectFromGalleryOthers('gallery');
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
                                decoration: BoxDecoration(
                                  color: ThemeProvider.surfaceTint,
                                  border: Border.all(color: ThemeProvider.appColor.withOpacity(0.35), width: 1.4),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.1), shape: BoxShape.circle),
                                      child: const Icon(Icons.add_photo_alternate_outlined, color: ThemeProvider.appColor, size: 20),
                                    ),
                                    const SizedBox(height: 8),
                                    Text('Upload Image'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, color: ThemeProvider.appColor, fontFamily: 'medium')),
                                  ],
                                ),
                              ),
                            )
                          : Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.gallery[index].toString()}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                      },
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: InkWell(
                                    onTap: () => value.deletePhoto(value.gallery[index]),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: ThemeProvider.redColor, shape: BoxShape.circle, boxShadow: ThemeProvider.cardShadow),
                                      child: const Icon(Icons.close, color: ThemeProvider.whiteColor, size: 14),
                                    ),
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              child: InkWell(
                borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                onTap: () => value.onSave(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  decoration: contentButtonStyle(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Update Images'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'bold')),
                    ],
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
    borderRadius: const BorderRadius.all(Radius.circular(100.0)),
    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
    boxShadow: [BoxShadow(color: ThemeProvider.appColor.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
  );
}
