import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/individual_packages_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';

class IndividualPackagesScreen extends StatefulWidget {
  const IndividualPackagesScreen({super.key});

  @override
  State<IndividualPackagesScreen> createState() => _IndividualPackagesScreenState();
}

class _IndividualPackagesScreenState extends State<IndividualPackagesScreen> {
  final ScrollController _scrollController = ScrollController();

  bool lastStatus = true;
  var top = 0.0;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients && _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualPackagesController>(
      builder: (value) {
        return value.apiCalled == false
            ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
            : NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: ThemeProvider.surfaceTint,
                      pinned: true,
                      snap: false,
                      floating: true,
                      elevation: 0,
                      expandedHeight: 230.0,
                      iconTheme: const IconThemeData(color: ThemeProvider.textPrimary),
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: isShrink ? Colors.transparent : Colors.black.withOpacity(0.28),
                          child: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back, color: isShrink ? ThemeProvider.textPrimary : ThemeProvider.whiteColor, size: 18)),
                        ),
                      ),
                      title: Text('Packages Details'.tr, style: TextStyle(color: isShrink ? ThemeProvider.textPrimary : ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 15)),
                      flexibleSpace: LayoutBuilder(
                        builder: (ctx, cons) {
                          top = cons.biggest.height;
                          return FlexibleSpaceBar(
                            centerTitle: true,
                            title: AnimatedOpacity(opacity: top <= 80 ? 1.0 : 0.0, duration: const Duration(microseconds: 200)),
                            background: SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: FadeInImage(
                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.packagesDetails.cover}'),
                                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ];
                },
                body: Scaffold(
                  backgroundColor: ThemeProvider.surfaceTint,
                  bottomNavigationBar: value.packagesDetails.isBooked == false
                      ? SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                              onTap: () => value.addPackageToCart(),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                decoration: contentButtonStyle(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add_shopping_cart, color: ThemeProvider.whiteColor, size: 18),
                                    const SizedBox(width: 8),
                                    Text('Book Now'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 16, fontFamily: 'semibold')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                    onTap: () => value.removePackageFromCart(),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      decoration: BoxDecoration(color: ThemeProvider.redColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                      child: Center(child: Text('Remove Package'.tr, style: const TextStyle(fontFamily: 'semibold', color: ThemeProvider.whiteColor, fontSize: 13))),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                    onTap: () => value.onCheckout(),
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                      child: Center(child: Text('Checkout'.tr, style: const TextStyle(fontFamily: 'semibold', color: ThemeProvider.whiteColor, fontSize: 13))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(value.packagesDetails.name.toString(), style: const TextStyle(fontSize: 20, fontFamily: 'bold', color: ThemeProvider.textPrimary)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.schedule, size: 14, color: ThemeProvider.textSecondary),
                                  const SizedBox(width: 4),
                                  Text('${value.packagesDetails.duration}${' min'.tr}', style: const TextStyle(fontSize: 12.5, color: ThemeProvider.textSecondary)),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _priceCard(value),
                              _sectionTitle('Services Included'.tr),
                              Container(
                                decoration: ThemeProvider.cardDecoration(),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                child: Column(
                                  children: List.generate(
                                    value.packagesDetails.services!.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.check_circle, size: 15, color: ThemeProvider.appColor),
                                                const SizedBox(width: 8),
                                                Expanded(child: Text(value.packagesDetails.services![index].name.toString(), style: const TextStyle(fontSize: 13.5, color: ThemeProvider.textPrimary))),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            value.currencySide == 'left' ? '${value.currencySymbol}  ${value.packagesDetails.services![index].price}' : '  ${value.packagesDetails.services![index].price}${value.currencySymbol}',
                                            style: const TextStyle(fontSize: 13, color: ThemeProvider.textSecondary, fontFamily: 'medium'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              _sectionTitle('About'.tr),
                              Text(value.packagesDetails.descriptions.toString(), style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14, height: 1.5)),
                              _sectionTitle('Photos'.tr),
                              value.gallery.isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                          value.gallery.length,
                                          (index) => Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: SizedBox.fromSize(
                                                size: const Size.fromRadius(35),
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
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      child: Center(child: Text('No Photos Found'.tr, style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13))),
                                    ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [Text(text, style: const TextStyle(fontFamily: 'semibold', color: ThemeProvider.textPrimary, fontSize: 15))],
      ),
    );
  }

  Widget _priceCard(IndividualPackagesController value) {
    final currencySide = Get.find<IndividualPackagesController>().currencySide;
    final currencySymbol = Get.find<IndividualPackagesController>().currencySymbol;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: ThemeProvider.cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Price'.tr, style: const TextStyle(fontFamily: 'semibold', color: ThemeProvider.textPrimary, fontSize: 14)),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: currencySide == 'left' ? '${currencySymbol}  ${value.packagesDetails.price}' : '  ${value.packagesDetails.price}$currencySymbol',
                  style: const TextStyle(fontSize: 13, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                ),
                TextSpan(
                  text: currencySide == 'left' ? '   ${currencySymbol}  ${value.packagesDetails.off}' : '   ${value.packagesDetails.off}$currencySymbol',
                  style: const TextStyle(fontSize: 16, color: ThemeProvider.appColor, fontFamily: 'bold'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

contentButtonStyle() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(100.0)),
    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
}
