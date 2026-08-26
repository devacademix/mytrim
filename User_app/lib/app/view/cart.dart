import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text('Cart'.tr, style: ThemeProvider.titleStyle),
          ),
          bottomNavigationBar: value.savedInCart.isEmpty
              ? null
              : SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => value.onCheckout(),
                        style: ElevatedButton.styleFrom(backgroundColor: ThemeProvider.appColor, elevation: 0, shape: const StadiumBorder()),
                        child: Text('Continue'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 16)),
                      ),
                    ),
                  ),
                ),
          body: value.savedInCart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.08)),
                        child: const Icon(Icons.shopping_cart_outlined, size: 40, color: ThemeProvider.appColor),
                      ),
                      const SizedBox(height: 20),
                      Text('Your cart is empty'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
                      const SizedBox(height: 6),
                      Text('Add products to see them here'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 13, color: ThemeProvider.textSecondary)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: value.savedInCart.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) => Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: ThemeProvider.cardDecoration(),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: FadeInImage(
                                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.savedInCart[i].cover}'),
                                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            value.savedInCart[i].name.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.textPrimary),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => value.deleteProductFromCart(i),
                                          borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                          child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.delete_outline, size: 20, color: ThemeProvider.redColor)),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      value.savedInCart[i].descriptions.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12, height: 1.4),
                                    ),
                                    const SizedBox(height: 6),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: value.currencySide == 'left' ? value.currencySymbol + value.savedInCart[i].sellPrice.toString() : value.savedInCart[i].sellPrice.toString() + value.currencySymbol,
                                            style: const TextStyle(fontSize: 13, color: ThemeProvider.appColor, fontFamily: 'bold'),
                                          ),
                                          TextSpan(
                                            text: value.currencySide == 'left'
                                                ? '  ${value.currencySymbol}${value.savedInCart[i].originalPrice}'
                                                : '  ${value.savedInCart[i].originalPrice}${value.currencySymbol}',
                                            style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          InkWell(
                                            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                            onTap: () => value.updateProductQuantityRemove(i),
                                            child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.remove, color: ThemeProvider.textPrimary, size: 15)),
                                          ),
                                          SizedBox(
                                            width: 26,
                                            child: Text(
                                              value.savedInCart[i].quantity.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontSize: 13, fontFamily: 'semibold', color: ThemeProvider.textPrimary),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                            onTap: () => value.updateProductQuantity(i),
                                            child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.add, color: ThemeProvider.textPrimary, size: 15)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: 'Special Discount : '.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                      TextSpan(
                                        text: '${value.savedInCart[i].discount}${' %OFF'.tr}',
                                        style: const TextStyle(fontSize: 12, color: ThemeProvider.redColor, fontFamily: 'semibold'),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: 'Total Price : '.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                      TextSpan(
                                        text: value.currencySide == 'left' ? value.currencySymbol + value.getFinalTotal(i).toString() : value.getFinalTotal(i).toString() + value.currencySymbol,
                                        style: const TextStyle(fontSize: 13, color: ThemeProvider.greenColor, fontFamily: 'bold'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
