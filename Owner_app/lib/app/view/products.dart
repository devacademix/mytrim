import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/products_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50,
            title: Text('Products'.tr, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: ThemeProvider.titleStyle),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Material(
                  color: ThemeProvider.whiteColor,
                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                    onTap: () => value.onCreateProducts(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, size: 16, color: ThemeProvider.appColor),
                          const SizedBox(width: 4),
                          Text('Add New'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                child: SizedBox(
                  height: 42,
                  child: TextField(
                    style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search for Salon, Services....'.tr,
                      prefixIcon: const Icon(Icons.search, color: ThemeProvider.mutedTextColor, size: 20),
                      hintStyle: const TextStyle(color: ThemeProvider.subtleTextColor, fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: ThemeProvider.whiteColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.productsInfo.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/no-data.png', width: 72, height: 72),
                          const SizedBox(height: 18),
                          Text('No Products Found!'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.mutedTextColor)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                      itemCount: value.productsInfo.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = value.productsInfo[index];
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: ThemeProvider.cardDecoration(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(28),
                                  child: FadeInImage(
                                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
                                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 56, width: 56);
                                    },
                                    fit: BoxFit.cover,
                                    height: 56,
                                    width: 56,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.name.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor),
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                          onTap: () => value.updateStatus(item.id as int, item.status as int),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(
                                              item.status == 1 ? Icons.visibility : Icons.visibility_off,
                                              size: 18,
                                              color: item.status == 1 ? const Color(0xFF16A34A) : ThemeProvider.subtleTextColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                          onTap: () => value.onUpdateProducts(item.id as int),
                                          child: const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(Icons.edit_note, size: 20, color: ThemeProvider.appColor),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.cardRadius)),
                                                  contentPadding: const EdgeInsets.all(20),
                                                  content: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Image.asset('assets/images/delete.png', fit: BoxFit.cover, height: 80, width: 80),
                                                        const SizedBox(height: 20),
                                                        Text('Are you sure'.tr, style: const TextStyle(fontSize: 22, fontFamily: 'semi-bold')),
                                                        const SizedBox(height: 8),
                                                        Text('to delete Slots ?'.tr, style: const TextStyle(color: ThemeProvider.mutedTextColor)),
                                                        const SizedBox(height: 20),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: ElevatedButton(
                                                                onPressed: () => Navigator.pop(context),
                                                                style: ElevatedButton.styleFrom(
                                                                  foregroundColor: ThemeProvider.backgroundColor,
                                                                  backgroundColor: ThemeProvider.redColor,
                                                                  minimumSize: const Size.fromHeight(42),
                                                                  elevation: 0,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                                ),
                                                                child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 15)),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 14),
                                                            Expanded(
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                  value.destroyProduct(item.id as int);
                                                                  Navigator.pop(context);
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  foregroundColor: ThemeProvider.backgroundColor,
                                                                  backgroundColor: ThemeProvider.greenColor,
                                                                  minimumSize: const Size.fromHeight(42),
                                                                  elevation: 0,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                                ),
                                                                child: Text('Delete'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 15)),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(Icons.delete_outline, size: 20, color: ThemeProvider.redColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: value.currencySide == 'left' ? '${value.currencySymbol}  ${item.originalPrice.toString()}' : '  ${item.originalPrice.toString()}${value.currencySymbol}',
                                            style: const TextStyle(fontSize: 12, color: ThemeProvider.subtleTextColor, decoration: TextDecoration.lineThrough),
                                          ),
                                          const TextSpan(text: '  '),
                                          TextSpan(
                                            text: value.currencySide == 'left' ? '${value.currencySymbol}  ${item.sellPrice.toString()}' : '  ${item.sellPrice.toString()}${value.currencySymbol}',
                                            style: const TextStyle(fontSize: 13, color: ThemeProvider.appColor, fontFamily: 'bold'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
