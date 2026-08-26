import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/view/account.dart';
import 'package:user/app/view/booking.dart';
import 'package:user/app/view/categories.dart';
import 'package:user/app/view/home.dart';
import 'package:user/app/view/near.dart';
import 'package:badges/badges.dart' as badges;

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabsController>(builder: (value) {
      return DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: ThemeProvider.whiteColor,
              boxShadow: [BoxShadow(color: ThemeProvider.blackColor.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, -4))],
            ),
            child: SafeArea(
              top: false,
              child: TabBar(
                controller: value.tabController,
                labelColor: ThemeProvider.appColor,
                unselectedLabelColor: ThemeProvider.textSecondary,
                indicatorColor: Colors.transparent,
                labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                labelStyle: const TextStyle(fontFamily: 'medium', fontSize: 12),
                onTap: (int index) => value.updateTabId(index),
                tabs: [
                  Tab(
                    icon: Icon(value.tabId != 0 ? Icons.home_outlined : Icons.home_sharp, color: value.tabId == 0 ? ThemeProvider.appColor : ThemeProvider.textSecondary),
                    text: 'Home'.tr,
                  ),
                  Tab(
                    icon: Icon(value.tabId != 1 ? Icons.location_on_outlined : Icons.location_on, color: value.tabId == 1 ? ThemeProvider.appColor : ThemeProvider.textSecondary),
                    text: 'NearBy'.tr,
                  ),
                  Tab(
                    icon: value.cartTotal > 0
                        ? badges.Badge(
                            badgeStyle: const badges.BadgeStyle(badgeColor: ThemeProvider.appColor),
                            badgeContent: Text(value.cartTotal.toString(), style: const TextStyle(color: ThemeProvider.whiteColor)),
                            child: Icon(
                              value.tabId != 2 ? Icons.shopping_cart_outlined : Icons.shopping_cart,
                              color: value.tabId == 2 ? ThemeProvider.appColor : ThemeProvider.textSecondary,
                            ),
                          )
                        : Icon(
                            value.tabId != 2 ? Icons.shopping_cart_outlined : Icons.shopping_cart,
                            color: value.tabId == 2 ? ThemeProvider.appColor : ThemeProvider.textSecondary,
                          ),
                    text: 'Shop'.tr,
                  ),
                  Tab(
                    icon: Icon(value.tabId != 3 ? Icons.calendar_today_outlined : Icons.calendar_today, color: value.tabId == 3 ? ThemeProvider.appColor : ThemeProvider.textSecondary),
                    text: 'Appoinment'.tr,
                  ),
                  Tab(
                    icon: Icon(value.tabId != 4 ? Icons.account_circle_outlined : Icons.account_circle, color: value.tabId == 4 ? ThemeProvider.appColor : ThemeProvider.textSecondary),
                    text: 'Account'.tr,
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: value.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [HomeScreen(), NearScreen(), CategoriesScreen(), BookingScreen(), AccountScreen()],
          ),
        ),
      );
    });
  }
}
