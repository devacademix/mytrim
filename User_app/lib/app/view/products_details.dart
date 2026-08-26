import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/products_details_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';

class ProductsDetailsScreen extends StatefulWidget {
  const ProductsDetailsScreen({super.key});

  @override
  State<ProductsDetailsScreen> createState() => _ProductsDetailsScreenState();
}

class _ProductsDetailsScreenState extends State<ProductsDetailsScreen> {
  var top = 0.0;

  final ScrollController _scrollController = ScrollController();

  bool lastStatus = true;

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

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'semibold', fontSize: 15)),
      );

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: '$label  ', style: const TextStyle(fontSize: 13, fontFamily: 'medium', color: ThemeProvider.textPrimary)),
              TextSpan(text: value, style: const TextStyle(fontSize: 13, color: ThemeProvider.textSecondary)),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsDetailsController>(
      builder: (value) {
        return value.apiCalled == false
            ? const Scaffold(
                backgroundColor: ThemeProvider.surfaceTint,
                body: Center(child: CircularProgressIndicator(color: ThemeProvider.appColor)),
              )
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
                      iconTheme: const IconThemeData(color: Colors.black),
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: isShrink ? ThemeProvider.surfaceTint : ThemeProvider.blackColor.withOpacity(0.35),
                          child: IconButton(icon: Icon(Icons.arrow_back, color: isShrink ? ThemeProvider.blackColor : ThemeProvider.whiteColor), onPressed: () => Get.back()),
                        ),
                      ),
                      title: Text('Products Details'.tr, style: TextStyle(color: isShrink ? ThemeProvider.textPrimary : ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 15)),
                      flexibleSpace: LayoutBuilder(
                        builder: (ctx, cons) {
                          top = cons.biggest.height;
                          return FlexibleSpaceBar(
                            centerTitle: true,
                            title: AnimatedOpacity(
                              opacity: top <= 80 ? 1.0 : 0.0,
                              duration: const Duration(microseconds: 200),
                            ),
                            background: SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: FadeInImage(
                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.productsList.cover.toString()}'),
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
                  backgroundColor: ThemeProvider.whiteColor,
                  bottomNavigationBar: value.apiCalled == false
                      ? const SizedBox()
                      : SafeArea(
                          top: false,
                          child: Container(
                            decoration: BoxDecoration(color: ThemeProvider.surfaceColor, boxShadow: ThemeProvider.cardShadow),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                value.productsList.quantity == 0
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Total Price'.tr, style: const TextStyle(fontFamily: 'medium', color: ThemeProvider.textSecondary, fontSize: 13)),
                                            Text(value.getTotal().toString(), style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.textPrimary, fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                                  child: value.productsList.quantity == 0
                                      ? SizedBox(
                                          height: 50,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () => value.addToCart(),
                                            style: ElevatedButton.styleFrom(backgroundColor: ThemeProvider.appColor, elevation: 0, shape: const StadiumBorder()),
                                            child: Text('Add To Cart'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 16)),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 130,
                                                height: 50,
                                                decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    InkWell(
                                                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                                      onTap: () => value.updateProductQuantityRemove(),
                                                      child: const CircleAvatar(radius: 15, backgroundColor: ThemeProvider.appColor, child: Icon(Icons.remove, color: ThemeProvider.whiteColor, size: 15)),
                                                    ),
                                                    Text(value.productsList.quantity.toString(), style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'semibold')),
                                                    InkWell(
                                                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                                      onTap: () => value.updateProductQuantity(),
                                                      child: const CircleAvatar(radius: 15, backgroundColor: ThemeProvider.appColor, child: Icon(Icons.add, color: ThemeProvider.whiteColor, size: 15)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    onPressed: () => value.onCheckout(),
                                                    style: ElevatedButton.styleFrom(backgroundColor: ThemeProvider.appColor, elevation: 0, shape: const StadiumBorder()),
                                                    child: Text('Checkout'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 16)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value.productsList.name.toString(),
                            style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.textPrimary, fontSize: 19),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: ThemeProvider.cardDecoration(color: ThemeProvider.surfaceTint),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoRow('Sold By :'.tr, '${value.soldByInfo.firstName}  ${value.soldByInfo.lastName}'),
                                _infoRow('Categories Info :'.tr, value.cateInfo.name.toString()),
                                _infoRow('Sub Categories Info :'.tr, value.subCateInfo.name.toString()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _sectionLabel('Descriptions'.tr),
                          Text(value.productsList.descriptions.toString(), style: const TextStyle(fontSize: 14, color: ThemeProvider.textSecondary, height: 1.5)),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(color: ThemeProvider.greenColor.withOpacity(0.08), borderRadius: BorderRadius.circular(ThemeProvider.cardRadius)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Special Price'.tr, style: const TextStyle(color: ThemeProvider.greenColor, fontFamily: 'semibold', fontSize: 13)),
                                const SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: Get.find<ProductsDetailsController>().currencySide == 'left'
                                            ? '${Get.find<ProductsDetailsController>().currencySymbol} ${value.productsList.sellPrice}'
                                            : '${value.productsList.sellPrice}${Get.find<ProductsDetailsController>().currencySymbol}',
                                        style: const TextStyle(fontSize: 18, color: ThemeProvider.appColor, fontFamily: 'bold'),
                                      ),
                                      const TextSpan(text: '  '),
                                      TextSpan(
                                        text: Get.find<ProductsDetailsController>().currencySide == 'left'
                                            ? '${Get.find<ProductsDetailsController>().currencySymbol} ${value.productsList.originalPrice}'
                                            : '${value.productsList.originalPrice}${Get.find<ProductsDetailsController>().currencySymbol}',
                                        style: const TextStyle(fontSize: 13, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                      ),
                                      TextSpan(text: '  ${value.productsList.discount}${' % Off '.tr}', style: const TextStyle(fontSize: 13, color: ThemeProvider.greenColor, fontFamily: 'bold')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, color: ThemeProvider.redColor, size: 16),
                              const SizedBox(width: 6),
                              Text('Only 5 Days Left'.tr, style: const TextStyle(color: ThemeProvider.redColor, fontFamily: 'semibold', fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _sectionLabel('Disclaimer'.tr),
                          Text(value.productsList.disclaimer.toString(), style: const TextStyle(fontSize: 14, color: ThemeProvider.textSecondary, height: 1.5)),
                          const SizedBox(height: 20),
                          _sectionLabel('Related Products'.tr),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                value.relatedList.length,
                                (index) => Container(
                                  width: 90,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: ThemeProvider.cardDecoration(),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: FadeInImage(
                                            image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.relatedList[index].cover.toString()}'),
                                            placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                            },
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        value.relatedList[index].name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 11, fontFamily: 'medium'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
}
