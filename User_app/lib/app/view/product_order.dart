import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/backend/models/product_salon_model.dart';
import 'package:user/app/controller/product_order_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class ProductOrderScreen extends StatefulWidget {
  const ProductOrderScreen({super.key});

  @override
  State<ProductOrderScreen> createState() => _ProductOrderScreenState();
}

class _ProductOrderScreenState extends State<ProductOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductOrderController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            title: Text('Order History'.tr, style: ThemeProvider.titleStyle),
            bottom: value.parser.haveLoggedIn() == true
                ? TabBar(
                    controller: value.tabController,
                    unselectedLabelColor: ThemeProvider.whiteColor.withOpacity(0.65),
                    labelColor: ThemeProvider.whiteColor,
                    indicatorColor: ThemeProvider.whiteColor,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15),
                    unselectedLabelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Text('New'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
                      Text('Old'.tr, style: const TextStyle(color: ThemeProvider.whiteColor)),
                    ],
                  )
                : null,
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : TabBarView(
                  controller: value.tabController,
                  children: [
                    _OrderList(items: value.productSalonList, value: value, emptyMessage: 'No New Orders Found!'.tr),
                    _OrderList(items: value.productSalonListOld, value: value, emptyMessage: 'No Past Orders Found!'.tr),
                  ],
                ),
        );
      },
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.items, required this.value, required this.emptyMessage});

  final List<ProductSalonModel> items;
  final ProductOrderController value;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _OrderCard(items: items, value: value, index: index),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/no-data.png', width: 72, height: 72),
          const SizedBox(height: 18),
          Text(message, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.textSecondary)),
        ],
      ),
    );
  }
}

Color _statusColor(int status) {
  switch (status) {
    case 0: // Created
      return ThemeProvider.orangeColor;
    case 1: // Accepted
      return ThemeProvider.secondaryAppColor;
    case 2: // Rejected
      return ThemeProvider.redColor;
    case 3: // Ongoing
      return ThemeProvider.appColor;
    case 4: // Completed
      return ThemeProvider.greenColor;
    case 5: // Cancelled
      return ThemeProvider.redColor;
    case 6: // Refunded
      return ThemeProvider.textSecondary;
    case 7: // Delayed
      return ThemeProvider.orangeColor;
    default: // Pending payment / other
      return ThemeProvider.orangeColor;
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.items, required this.value, required this.index});

  final List<ProductSalonModel> items;
  final ProductOrderController value;
  final int index;

  String _money(Object? amount) {
    final text = amount.toString();
    return value.currencySide == 'left' ? '${value.currencySymbol}$text' : '$text${value.currencySymbol}';
  }

  @override
  Widget build(BuildContext context) {
    final item = items[index];
    final status = item.status as int;
    final statusColor = _statusColor(status);
    final orders = item.orders ?? [];

    return Material(
      color: ThemeProvider.transparent,
      borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
        onTap: () => value.onProductDetail(item.id as int),
        child: Container(
          decoration: ThemeProvider.cardDecoration(),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 44,
                      width: 44,
                      child: FadeInImage(
                        image: NetworkImage(
                            '${Environments.apiBaseURL}storage/images/${item.type == 'salon' ? item.salonInfo!.cover.toString() : item.freelancerInfo!.cover.toString()}'),
                        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 44, width: 44);
                        },
                        fit: BoxFit.cover,
                        height: 44,
                        width: 44,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.type == 'salon' ? item.salonInfo!.name.toString() : '${item.freelancerInfo!.firstName} ${item.freelancerInfo!.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.textPrimary),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item.address!.address} ${item.address!.landmark} ${item.address!.pincode}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary),
                        ),
                        const SizedBox(height: 3),
                        Text('${'Order Id #'.tr} ${item.id}', style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                    child: Text(value.statusName[status].tr, style: TextStyle(fontFamily: 'bold', fontSize: 10, color: statusColor)),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: ThemeProvider.borderColor)),
              ...List.generate(
                orders.length,
                (subIndex) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '${orders[subIndex].name} ${'X'.tr} ${orders[subIndex].quantity}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: _money(orders[subIndex].originalPrice), style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough)),
                            const TextSpan(text: '  '),
                            TextSpan(text: _money(orders[subIndex].sellPrice), style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary, fontFamily: 'bold')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Grand Total'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'bold', color: ThemeProvider.textPrimary)),
                        Text(_money(item.grandTotal), style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.appColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event_outlined, size: 14, color: ThemeProvider.textSecondary),
                            const SizedBox(width: 4),
                            Text('Order At'.tr, style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary)),
                          ],
                        ),
                        Text(item.createdAt.toString(), style: const TextStyle(fontSize: 11, fontFamily: 'medium', color: ThemeProvider.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
