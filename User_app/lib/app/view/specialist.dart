import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/controller/specialist_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/util/theme.dart';

class SpecialistScreen extends StatefulWidget {
  const SpecialistScreen({super.key});

  @override
  State<SpecialistScreen> createState() => _SpecialistScreenState();
}

class _SpecialistScreenState extends State<SpecialistScreen> {
  int tabID = 1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpecialistController>(
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
                      toolbarHeight: 400,
                      snap: false,
                      elevation: 0,
                      forceElevated: true,
                      iconTheme: const IconThemeData(color: ThemeProvider.appColor),
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      title: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: 200,
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 50),
                                child: FadeInImage(
                                  image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.individualDetails.background.toString()}'),
                                  placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                height: 200,
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 50),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [ThemeProvider.blackColor.withOpacity(0.35), ThemeProvider.blackColor.withOpacity(0.0)]),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: ThemeProvider.whiteColor.withOpacity(0.2),
                                        child: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: ThemeProvider.surfaceTint, border: Border.all(color: ThemeProvider.appColor, width: 3), borderRadius: BorderRadius.circular(100), boxShadow: ThemeProvider.cardShadow),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(40),
                                          child: FadeInImage(
                                            image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.userInfo.cover.toString()}'),
                                            placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                            },
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 3,
                                      bottom: 3,
                                      child: Container(
                                        height: 14,
                                        width: 14,
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.greenColor, border: Border.all(color: ThemeProvider.surfaceTint, width: 2)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: -40,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), color: ThemeProvider.greenColor.withOpacity(0.12)),
                                  child: Text('OPEN'.tr, style: const TextStyle(color: ThemeProvider.greenColor, fontSize: 10, fontFamily: 'semibold')),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${value.userInfo.firstName} ${value.userInfo.lastName}', style: const TextStyle(fontFamily: 'semibold', fontSize: 16, color: ThemeProvider.textPrimary)),
                          const SizedBox(height: 2),
                          Text(value.userInfo.email.toString(), style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: value.individualDetails.rating! >= 1 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: value.individualDetails.rating! >= 2 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: value.individualDetails.rating! >= 3 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: value.individualDetails.rating! >= 4 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                  WidgetSpan(child: Icon(Icons.star, size: 15, color: value.individualDetails.rating! >= 5 ? ThemeProvider.orangeColor : ThemeProvider.borderColor)),
                                  TextSpan(text: ' ( ${value.individualDetails.totalRating} ${'Reviews)'.tr}', style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildActionIcon(icon: Icons.language, color: ThemeProvider.secondaryAppColor, label: 'Website'.tr, onTap: () => value.openWebsite()),
                                _buildActionIcon(icon: Icons.call, color: ThemeProvider.greenColor, label: 'Call'.tr, onTap: () => value.callIndividual()),
                                _buildActionIcon(icon: Icons.chat_outlined, color: ThemeProvider.orangeColor, label: 'Chat'.tr, onTap: () => value.onChat()),
                                _buildActionIcon(icon: Icons.directions, color: ThemeProvider.redColor, label: 'Direction'.tr, onTap: () => value.openMap()),
                                _buildActionIcon(icon: Icons.share, color: ThemeProvider.orangeColor, label: 'Share'.tr, onTap: () => value.share()),
                              ],
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
                          backgroundColor: ThemeProvider.surfaceTint,
                          title: DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                TabBar(
                                  controller: value.tabController,
                                  labelColor: ThemeProvider.appColor,
                                  isScrollable: false,
                                  labelStyle: const TextStyle(fontFamily: 'semibold', fontSize: 13),
                                  unselectedLabelColor: ThemeProvider.textSecondary,
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  indicator: const UnderlineTabIndicator(borderSide: BorderSide(width: 2.5, color: ThemeProvider.appColor)),
                                  tabs: [
                                    Tab(text: 'Basic Info'.tr),
                                    Tab(text: 'Portfolio'.tr),
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
                                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: ThemeProvider.cardDecoration(),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('About'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                              const SizedBox(height: 8),
                                              Text(value.individualDetails.about.toString(), style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13, height: 1.5)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: ThemeProvider.cardDecoration(),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Opening Hour'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                              const SizedBox(height: 10),
                                              Column(
                                                children: List.generate(
                                                  value.individualDetails.timing!.length,
                                                  (index) => Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                                    child: Row(
                                                      children: [
                                                        Container(height: 8, width: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.greenColor)),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(value.dayList[value.individualDetails.timing![index].day as int], style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12)),
                                                              Text(
                                                                '${value.individualDetails.timing![index].openTime}   :   ${value.individualDetails.timing![index].closeTime}',
                                                                style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 12, fontFamily: 'medium'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: ThemeProvider.cardDecoration(),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Address'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                              const SizedBox(height: 10),
                                              Row(
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
                                                            value.individualDetails.address.toString(),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              const WidgetSpan(child: Icon(Icons.near_me_outlined, size: 15, color: ThemeProvider.orangeColor)),
                                                              TextSpan(text: ' Get Direction - ${value.getDistance}${'KM'.tr}', style: const TextStyle(fontSize: 12, color: ThemeProvider.orangeColor, fontFamily: 'medium')),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(14),
                                                    child: SizedBox.fromSize(
                                                      size: const Size.fromRadius(35),
                                                      child: GoogleMap(
                                                        onMapCreated: value.onMapCreated(),
                                                        markers: value.markers,
                                                        initialCameraPosition: CameraPosition(target: LatLng(value.individualDetails.lat as double, value.individualDetails.lng as double), zoom: 5),
                                                        myLocationButtonEnabled: false,
                                                        zoomControlsEnabled: false,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                                          decoration: ThemeProvider.cardDecoration(),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 16),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('Photos'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                                    Text('View All'.tr, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary)),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                height: 90,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: List.generate(
                                                      value.gallery.length,
                                                      (index) => Padding(
                                                        padding: const EdgeInsets.only(right: 10.0),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(14),
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
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Column(
                                      children: [
                                        _buildSegment(),
                                        const SizedBox(height: 12),
                                        if (tabID == 1)
                                          value.categoriesList.isNotEmpty
                                              ? Column(
                                                  children: List.generate(
                                                    value.categoriesList.length,
                                                    (index) => Container(
                                                      padding: const EdgeInsets.all(10),
                                                      margin: const EdgeInsets.only(bottom: 12),
                                                      decoration: ThemeProvider.cardDecoration(),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(12),
                                                            child: Container(
                                                              height: 60,
                                                              width: 60,
                                                              color: ThemeProvider.surfaceTint,
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(8),
                                                                child: FadeInImage(
                                                                  image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.categoriesList[index].cover.toString()}'),
                                                                  placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                                    return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                                                  },
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 12),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        value.categoriesList[index].name.toString(),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14, fontFamily: 'medium'),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () => value.onServicesView(value.categoriesList[index].id as int, value.categoriesList[index].name.toString()),
                                                                      child: Text('View'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 13, fontFamily: 'semibold')),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 4),
                                                                Text(
                                                                  value.categoriesList[index].services.toString() + '  Type'.tr,
                                                                  style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : _buildEmptyState('No Found'.tr, Icons.design_services_outlined)
                                        else if (tabID == 2)
                                          value.packagesList.isNotEmpty
                                              ? Column(
                                                  children: List.generate(
                                                    value.packagesList.length,
                                                    (index) => Container(
                                                      margin: const EdgeInsets.only(bottom: 16),
                                                      decoration: ThemeProvider.cardDecoration(),
                                                      clipBehavior: Clip.antiAlias,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: 150,
                                                            width: double.infinity,
                                                            child: FadeInImage(
                                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.packagesList[index].cover.toString()}'),
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
                                                                        value.packagesList[index].name.toString(),
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'semibold', fontSize: 14),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () => value.onPackagesDetails(value.packagesList[index].id as int, value.packagesList[index].name.toString()),
                                                                      child: Text('View'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'semibold', fontSize: 13)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 4),
                                                                Text(
                                                                  Get.find<SpecialistController>().currencySide == 'left'
                                                                      ? '${Get.find<SpecialistController>().currencySymbol}  ${value.packagesList[index].price}'
                                                                      : '  ${value.packagesList[index].price}${Get.find<SpecialistController>().currencySymbol}',
                                                                  style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : _buildEmptyState('No Found'.tr, Icons.card_giftcard_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${'All Reviews '.tr}(${value.ownerReviewsList.length})', style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13, fontFamily: 'medium')),
                                        const SizedBox(height: 12),
                                        value.ownerReviewsList.isNotEmpty
                                            ? Column(
                                                children: List.generate(
                                                value.ownerReviewsList.length,
                                                (index) => Container(
                                                  margin: const EdgeInsets.only(bottom: 12),
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: ThemeProvider.cardDecoration(),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
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
                                                          const SizedBox(width: 10),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        '${value.ownerReviewsList[index].user!.firstName!} ${value.ownerReviewsList[index].user!.lastName!}',
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.textPrimary),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Icon(Icons.star, color: ThemeProvider.orangeColor, size: 14),
                                                                        const SizedBox(width: 2),
                                                                        Text(
                                                                          value.ownerReviewsList[index].rating.toString(),
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 12, fontFamily: 'medium'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 2),
                                                                Row(
                                                                  children: [
                                                                    Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 1 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 13),
                                                                    Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 2 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 13),
                                                                    Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 3 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 13),
                                                                    Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 4 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 13),
                                                                    Icon(Icons.star, color: value.ownerReviewsList[index].rating! >= 5 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 13),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(value.ownerReviewsList[index].notes!, style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary, height: 1.4)),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                            : _buildEmptyState('No Found'.tr, Icons.reviews_outlined),
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
          bottomNavigationBar: Get.find<ServiceCartController>().totalItemsInCart > 0 && Get.find<ServiceCartController>().servicesFrom == 'individual'
              ? SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: InkWell(
                      onTap: () => value.onCheckout(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), boxShadow: ThemeProvider.cardShadow),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value.currencySide == 'left'
                                  ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
                                  : ' ${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
                              style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 13),
                            ),
                            Text('Book Services'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 13)),
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

  Widget _buildActionIcon({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(color: color.withOpacity(0.85), borderRadius: BorderRadius.circular(100), boxShadow: ThemeProvider.cardShadow),
            child: Icon(icon, size: 19, color: ThemeProvider.whiteColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary, fontFamily: 'medium')),
      ],
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.06)),
              child: Icon(icon, size: 36, color: ThemeProvider.appColor),
            ),
            const SizedBox(height: 18),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'semibold', fontSize: 14, color: ThemeProvider.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.06), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
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
              borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                  color: tabID == 1 ? ThemeProvider.appColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                ),
                child: Center(child: Text('Services'.tr, style: segmentText(1))),
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
              borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                  color: tabID == 2 ? ThemeProvider.appColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                ),
                child: Center(child: Text('Packages'.tr, style: segmentText(2))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  segmentText(val) {
    return TextStyle(fontSize: 12, fontFamily: 'medium', color: tabID == val ? ThemeProvider.whiteColor : ThemeProvider.textSecondary);
  }
}

contentButtonStyle() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(100.0)),
    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(229, 52, 1, 255), Color.fromARGB(228, 111, 75, 255)]),
  );
}
