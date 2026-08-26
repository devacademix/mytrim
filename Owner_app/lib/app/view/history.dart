import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:owner/app/backend/models/products_order_model.dart';
import 'package:owner/app/controller/history_controller.dart';
import 'package:owner/app/env.dart';
import 'package:owner/app/util/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
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
            bottom: TabBar(
              controller: value.tabController,
              unselectedLabelColor: ThemeProvider.whiteColor.withOpacity(0.65),
              labelColor: ThemeProvider.whiteColor,
              indicatorColor: ThemeProvider.whiteColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15),
              unselectedLabelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'New'.tr),
                Tab(text: 'Old'.tr),
              ],
            ),
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
  final HistoryController value;
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
      itemBuilder: (context, index) => _OrderCard(item: items[index], value: value),
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
          Text(message, style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.mutedTextColor)),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item, required this.value});

  final ProductSalonModel item;
  final HistoryController value;

  String _money(num? amount) {
    final text = amount.toString();
    return value.currencySide == 'left' ? '${value.currencySymbol}$text' : '$text${value.currencySymbol}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = ThemeProvider.statusColor(item.status as int);
    final orders = item.orders ?? [];

    return Material(
      color: ThemeProvider.whiteColor,
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
                    child: FadeInImage(
                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.userInfo!.cover.toString()}'),
                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                      imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 44, width: 44),
                      fit: BoxFit.cover,
                      height: 44,
                      width: 44,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.userInfo!.firstName} ${item.userInfo!.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.blackColor),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item.address!.address} ${item.address!.landmark} ${item.address!.pincode}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 12, color: ThemeProvider.mutedTextColor),
                        ),
                        const SizedBox(height: 3),
                        Text('${'Order Id #'.tr} ${item.id}', style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                    child: Text(value.statusName[item.status as int], style: TextStyle(fontFamily: 'bold', fontSize: 10, color: statusColor)),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: ThemeProvider.dividerColor)),
              ...orders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('${order.name} × ${order.quantity}', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor))),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: _money(order.originalPrice), style: const TextStyle(fontSize: 11, color: ThemeProvider.subtleTextColor, decoration: TextDecoration.lineThrough)),
                            const TextSpan(text: '  '),
                            TextSpan(text: _money(order.sellPrice), style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor, fontFamily: 'bold')),
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
                        Text('Grand Total'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'bold', color: ThemeProvider.blackColor)),
                        Text(_money(item.grandTotal), style: const TextStyle(fontSize: 14, fontFamily: 'bold', color: ThemeProvider.appColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event_outlined, size: 14, color: ThemeProvider.mutedTextColor),
                            const SizedBox(width: 4),
                            Text('Order At'.tr, style: const TextStyle(fontSize: 11, color: ThemeProvider.mutedTextColor)),
                          ],
                        ),
                        Text(item.createdAt.toString(), style: const TextStyle(fontSize: 11, fontFamily: 'medium', color: ThemeProvider.blackColor)),
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
