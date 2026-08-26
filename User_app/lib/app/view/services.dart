import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/controller/services_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int tabID = 1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServicesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          body: value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: ThemeProvider.surfaceTint,
                      floating: true,
                      pinned: true,
                      toolbarHeight: 470,
                      snap: false,
                      elevation: 0,
                      forceElevated: true,
                      iconTheme: const IconThemeData(color: ThemeProvider.appColor),
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      title: Column(
                        children: [
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.salonDetails.cover.toString()}'), fit: BoxFit.cover),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 110,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87]),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 56,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black54, Colors.transparent]),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _heroIconButton(icon: Icons.arrow_back, onTap: () => Get.back()),
                                          _heroIconButton(icon: Icons.save_alt, onTap: () {}),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        value.salonDetails.name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 19),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6, bottom: 8),
                                        child: Text(
                                          value.salonDetails.address.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: ThemeProvider.whiteColor.withOpacity(0.85), fontSize: 13),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.28), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  const WidgetSpan(child: Icon(Icons.star, size: 14, color: ThemeProvider.orangeColor)),
                                                  TextSpan(text: ' ${value.salonDetails.totalRating} ${'Reviews)'.tr}', style: const TextStyle(fontSize: 12, color: ThemeProvider.whiteColor)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 25,
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                              color: ThemeProvider.greenColor.withOpacity(0.16),
                                              border: Border.all(color: ThemeProvider.greenColor),
                                            ),
                                            child: Center(child: Text('OPEN'.tr, style: const TextStyle(color: ThemeProvider.greenColor, fontSize: 10, fontFamily: 'semibold'))),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: ThemeProvider.surfaceColor,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _actionIcon(icon: Icons.language, label: 'Website'.tr, onTap: () => value.openWebsite()),
                                _actionIcon(icon: Icons.call, label: 'Call'.tr, onTap: () => value.callSalon()),
                                _actionIcon(icon: Icons.chat_outlined, label: 'Chat'.tr, onTap: () => value.onChat()),
                                _actionIcon(icon: Icons.directions, label: 'Direction'.tr, onTap: () => value.openMap()),
                                _actionIcon(icon: Icons.offline_share, label: 'Share'.tr, onTap: () => value.share()),
                              ],
                            ),
                          ),
                          Container(
                            color: ThemeProvider.surfaceColor,
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                            child: Row(
                              children: [
                                Text('Salon Specialist'.tr, style: const TextStyle(fontSize: 15, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                              ],
                            ),
                          ),
                          Container(
                            color: ThemeProvider.surfaceColor,
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (var item in value.specialistList)
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0), border: Border.all(width: 2, color: ThemeProvider.appColor)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(100),
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(25),
                                                    child: FadeInImage(
                                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
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
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8, bottom: 3),
                                              child: Text('${item.firstName} ${item.lastName}', style: const TextStyle(fontSize: 12, color: ThemeProvider.textPrimary)),
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(56),
                        child: AppBar(
                          titleSpacing: 0,
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          backgroundColor: ThemeProvider.surfaceColor,
                          title: DefaultTabController(
                            length: 4,
                            child: Column(
                              children: [
                                TabBar(
                                  controller: value.tabController,
                                  labelColor: ThemeProvider.textPrimary,
                                  isScrollable: false,
                                  labelStyle: const TextStyle(fontFamily: 'semibold', fontSize: 13),
                                  unselectedLabelColor: ThemeProvider.textSecondary,
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  indicator: const UnderlineTabIndicator(borderSide: BorderSide(width: 2.5, color: ThemeProvider.appColor)),
                                  tabs: [
                                    Tab(text: 'About'.tr),
                                    Tab(text: 'Services'.tr),
                                    Tab(text: 'Gallary'.tr),
                                    Tab(text: 'Review'.tr),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(
                              controller: value.tabController,
                              children: [
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            _sectionTitle('About'.tr),
                                            Text(value.salonDetails.about.toString(), style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14, height: 1.5)),
                                            _sectionTitle('Opening Hour'.tr),
                                            Container(
                                              decoration: ThemeProvider.cardDecoration(),
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                              child: Column(
                                                children: List.generate(
                                                  value.salonDetails.timing!.length,
                                                  (index) => Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.circle, color: ThemeProvider.greenColor, size: 10),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(value.dayList[value.salonDetails.timing![index].day as int], style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13)),
                                                              Text(
                                                                '${value.salonDetails.timing![index].openTime}   -   ${value.salonDetails.timing![index].closeTime}',
                                                                style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 13, fontFamily: 'medium'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            _sectionTitle('Address'.tr),
                                            Container(
                                              decoration: ThemeProvider.cardDecoration(),
                                              padding: const EdgeInsets.all(12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Text(
                                                            value.salonDetails.address.toString(),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontSize: 12.5, color: ThemeProvider.textSecondary, height: 1.4),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              const WidgetSpan(child: Icon(Icons.near_me_outlined, size: 15, color: ThemeProvider.orangeColor)),
                                                              TextSpan(text: '${' Get Direction - '.tr}${value.getDistance}KM', style: const TextStyle(fontSize: 12, color: ThemeProvider.orangeColor, fontFamily: 'medium')),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(12),
                                                    child: SizedBox.fromSize(
                                                      size: const Size.fromRadius(35),
                                                      child: GoogleMap(
                                                        onMapCreated: value.onMapCreated(),
                                                        markers: value.markers,
                                                        initialCameraPosition: CameraPosition(target: LatLng(value.salonDetails.lat as double, value.salonDetails.lng as double), zoom: 5),
                                                        myLocationButtonEnabled: false,
                                                        zoomControlsEnabled: false,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 18, bottom: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Photos'.tr, style: const TextStyle(fontSize: 15, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                                  Text('View All'.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                                ],
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: List.generate(
                                                  value.gallery.length,
                                                  (index) => Padding(
                                                    padding: const EdgeInsets.only(right: 10, bottom: 4),
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
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                    child: Column(
                                      children: [
                                        _buildSegment(),
                                        const SizedBox(height: 6),
                                        if (tabID == 1)
                                          if (value.categoriesList.isEmpty)
                                            _emptyState('No Services Found'.tr)
                                          else
                                            for (var item in value.categoriesList) _buildCategoryCard(value, item)
                                        else if (tabID == 2)
                                          if (value.packagesList.isEmpty)
                                            _emptyState('No Packages Found'.tr)
                                          else
                                            for (var item in value.packagesList) _buildPackageCard(value, item),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: value.gallery.isNotEmpty
                                        ? Column(
                                            children: [
                                              GridView.count(
                                                primary: false,
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 12,
                                                crossAxisSpacing: 12,
                                                shrinkWrap: true,
                                                childAspectRatio: 100 / 100,
                                                padding: EdgeInsets.zero,
                                                children: List.generate(
                                                  value.gallery.length,
                                                  (index) {
                                                    return ClipRRect(
                                                      borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
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
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : _emptyState('No Photos Found'.tr),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 6),
                                          child: Row(
                                            children: [Text('${'All Reviews '.tr}(${value.ownerReviewsList.length})', style: const TextStyle(color: ThemeProvider.textSecondary, fontFamily: 'medium'))],
                                          ),
                                        ),
                                        value.ownerReviewsList.isNotEmpty
                                            ? Column(
                                                children: List.generate(
                                                value.ownerReviewsList.length,
                                                (index) => Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                                  decoration: ThemeProvider.cardDecoration(),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(100),
                                                              child: SizedBox.fromSize(
                                                                size: const Size.fromRadius(24),
                                                                child: FadeInImage(
                                                                  image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.ownerReviewsList[index].user!.cover.toString()}'),
                                                                  placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                                    return Image.asset('assets/images/notfound.png', fit: BoxFit.cover, height: 30, width: 30);
                                                                  },
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 120,
                                                                          child: Text(
                                                                            '${value.ownerReviewsList[index].user!.firstName!} ${value.ownerReviewsList[index].user!.lastName!}',
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.textPrimary),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            const Icon(Icons.star, color: ThemeProvider.orangeColor, size: 15),
                                                                            SizedBox(
                                                                              child: Text(
                                                                                value.ownerReviewsList[index].rating.toString(),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 12),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 1 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 14),
                                                                        Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 2 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 14),
                                                                        Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 3 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 14),
                                                                        Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 4 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 14),
                                                                        Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 5 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 14),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                                                        child: Text(value.ownerReviewsList[index].notes!, style: const TextStyle(fontSize: 12.5, color: ThemeProvider.textSecondary, height: 1.4)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                            : _emptyState('No Reviews Found'.tr),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: Get.find<ServiceCartController>().totalItemsInCart > 0 && Get.find<ServiceCartController>().servicesFrom == 'salon'
              ? SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                      onTap: () {
                        value.onCheckout();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.cardRadius), boxShadow: ThemeProvider.cardShadow),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value.currencySide == 'left'
                                  ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
                                  : ' ${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
                              style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'medium'),
                            ),
                            Row(
                              children: [
                                Text('Book Services'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold')),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward, color: ThemeProvider.whiteColor, size: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }

  Widget _heroIconButton({required IconData icon, required VoidCallback onTap}) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.black.withOpacity(0.28),
      child: IconButton(padding: EdgeInsets.zero, onPressed: onTap, icon: Icon(icon, color: ThemeProvider.whiteColor, size: 18)),
    );
  }

  Widget _actionIcon({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.08)),
            child: Icon(icon, size: 20, color: ThemeProvider.appColor),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [Text(text, style: const TextStyle(fontSize: 15, fontFamily: 'semibold', color: ThemeProvider.textPrimary))],
      ),
    );
  }

  Widget _emptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 80, width: 80, child: Image.asset("assets/images/no-data.png", fit: BoxFit.cover)),
          const SizedBox(height: 18),
          Center(child: Text(message, style: const TextStyle(fontFamily: 'medium', color: ThemeProvider.textSecondary, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(ServicesController value, dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: ThemeProvider.cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(20),
                  child: FadeInImage(
                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name.toString(), style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'semibold', fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.content_cut, size: 13, color: ThemeProvider.textSecondary),
                    const SizedBox(width: 4),
                    Text('${item.services}${' Type'.tr}', style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => value.onServicesView(item.id as int, item.name.toString()),
            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
              child: Text('View'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 12.5, fontFamily: 'semibold')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(ServicesController value, dynamic item) {
    final bool hasDiscount = item.discount != null && item.discount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: ThemeProvider.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            width: double.infinity,
            child: FadeInImage(
              image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
              },
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'semibold', fontSize: 15),
                      ),
                    ),
                    InkWell(
                      onTap: () => value.onPackagesDetails(item.id as int, item.name.toString()),
                      borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                        child: Text('View'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 12, fontFamily: 'semibold')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 13, color: ThemeProvider.textSecondary),
                    const SizedBox(width: 4),
                    Text('${item.duration}${' min'.tr}', style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12)),
                    const SizedBox(width: 12),
                    hasDiscount
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: Get.find<ServicesController>().currencySide == 'left' ? '${Get.find<ServicesController>().currencySymbol} ${item.price}' : '${item.price} ${Get.find<ServicesController>().currencySymbol}',
                                  style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary, decoration: TextDecoration.lineThrough),
                                ),
                                TextSpan(
                                  text: Get.find<ServicesController>().currencySide == 'left' ? '  ${Get.find<ServicesController>().currencySymbol} ${item.off}' : '  ${item.off} ${Get.find<ServicesController>().currencySymbol}',
                                  style: const TextStyle(fontSize: 13, color: ThemeProvider.appColor, fontFamily: 'bold'),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            Get.find<ServicesController>().currencySide == 'left'
                                ? '${Get.find<ServicesController>().currencySymbol}  ${item.price}'
                                : '  ${item.price}${Get.find<ServicesController>().currencySymbol}',
                            style: const TextStyle(color: ThemeProvider.appColor, fontSize: 13, fontFamily: 'bold'),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: ThemeProvider.appColor), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  tabID = 1;
                });
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: tabID == 1 ? ThemeProvider.appColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                ),
                child: Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30), child: Text('Services'.tr, style: segmentText(1)))),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  tabID = 2;
                });
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: tabID == 2 ? ThemeProvider.appColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                ),
                child: Center(
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30), child: Text('Packages'.tr, style: segmentText(2))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  segmentText(val) {
    return TextStyle(fontSize: 12.5, fontFamily: 'semibold', color: tabID == val ? ThemeProvider.whiteColor : ThemeProvider.textSecondary);
  }
}

contentButtonStyle() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(100.0)),
    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
}
