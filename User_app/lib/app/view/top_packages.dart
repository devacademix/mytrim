import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/top_packages_controller.dart';
import 'package:user/app/util/theme.dart';

class TopPackagesScreen extends StatefulWidget {
  const TopPackagesScreen({super.key});

  @override
  State<TopPackagesScreen> createState() => _TopPackagesScreenState();
}

class _TopPackagesScreenState extends State<TopPackagesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopPackagesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: ThemeProvider.appColor,
                floating: true,
                pinned: true,
                snap: false,
                elevation: 0,
                forceElevated: true,
                iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
                titleSpacing: 0,
                centerTitle: true,
                title: Text('Top Packages & Offers'.tr, style: ThemeProvider.titleStyle),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        child: Column(
                          children: [
                            for (var item in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]) _buildNewContent(value, item)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewContent(value, item) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: ThemeProvider.cardDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox.fromSize(size: const Size.fromRadius(40), child: FittedBox(fit: BoxFit.cover, child: Image.asset('assets/images/p1.jpg'))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ms.Jolly Jonthon'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'semibold', fontSize: 14.5, color: ThemeProvider.textPrimary)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.spa_outlined, size: 13, color: ThemeProvider.textSecondary),
                        const SizedBox(width: 4),
                        Text('Aromatherapy'.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: ' \$ 130 '.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough)),
                          TextSpan(text: ' 20% OFF '.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.greenColor, fontFamily: 'bold')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                          const WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                          const WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                          const WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                          const WidgetSpan(child: Icon(Icons.star, size: 15, color: ThemeProvider.orangeColor)),
                          const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 10), child: Icon(Icons.comment, size: 15, color: ThemeProvider.textSecondary))),
                          TextSpan(text: ' 11'.tr, style: const TextStyle(fontSize: 10, color: ThemeProvider.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: ThemeProvider.borderColor)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Fee start from '.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                    TextSpan(text: ' \$ 100 '.tr, style: const TextStyle(fontSize: 15, color: ThemeProvider.appColor, fontFamily: 'bold')),
                  ],
                ),
              ),
              InkWell(
                onTap: () => value.onBookAppointment(),
                borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                  child: Text('Continue'.tr, style: const TextStyle(fontSize: 11.5, fontFamily: 'semibold', color: ThemeProvider.whiteColor)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
