
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/service_cart_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/view/sidemenu.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _controller = CarouselSliderController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var top = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (value) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: ThemeProvider.surfaceTint,
          drawerEnableOpenDragGesture: false,
          drawer: const SideMenuScreen(),
          body: value.apiCalled == false
              ? SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 240,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Padding(padding: const EdgeInsets.all(10.0), child: SkeletonLine(style: SkeletonLineStyle(height: 220, width: double.infinity, borderRadius: BorderRadius.circular(0))))],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SkeletonParagraph(
                          style: SkeletonParagraphStyle(lines: 1, spacing: 6, lineStyle: SkeletonLineStyle(randomLength: true, height: 20, borderRadius: BorderRadius.circular(8), minLength: MediaQuery.of(context).size.width)),
                        ),
                      ),
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            7,
                            (index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: SkeletonAvatar(
                                style: SkeletonAvatarStyle(shape: BoxShape.circle, width: 60, height: 60),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          children: List.generate(
                            7,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SkeletonLine(
                                style: SkeletonLineStyle(height: 170, width: 250, borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            7,
                            (index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: SkeletonAvatar(
                                style: SkeletonAvatarStyle(shape: BoxShape.circle, width: 60, height: 60),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                            lines: 1,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 20,
                              borderRadius: BorderRadius.circular(8),
                              minLength: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          children: List.generate(
                            7,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SkeletonLine(
                                style: SkeletonLineStyle(height: 170, width: 250, borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: ThemeProvider.appColor,
                      pinned: true,
                      snap: false,
                      floating: true,
                      elevation: 0,
                      toolbarHeight: 70,
                      expandedHeight: 230.0,
                      iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
                      leading: IconButton(icon: const Icon(Icons.menu, color: ThemeProvider.whiteColor), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
                      flexibleSpace: LayoutBuilder(
                        builder: (ctx, cons) {
                          top = cons.biggest.height;
                          return FlexibleSpaceBar(
                            centerTitle: true,
                            title: AnimatedOpacity(
                              opacity: top <= 80 ? 1.0 : 0.0,
                              duration: const Duration(microseconds: 200),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 50),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                  onTap: () => value.onSearch(),
                                  child: Container(
                                    decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), boxShadow: [BoxShadow(color: ThemeProvider.blackColor.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 2))]),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Search salon, spa and barber'.tr, style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13)),
                                        const Icon(Icons.search_outlined, color: ThemeProvider.appColor, size: 18)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            background: ClipRRect(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/login.jpg'), fit: BoxFit.cover))),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [ThemeProvider.blackColor.withOpacity(0.55), ThemeProvider.blackColor.withOpacity(0.15), ThemeProvider.blackColor.withOpacity(0.55)],
                                      ),
                                    ),
                                  ),
                                  SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 30),
                                          InkWell(
                                            onTap: () => Get.toNamed(AppRouter.getFindLocationRoutes()),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.16), borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.location_on, color: Colors.white.withOpacity(0.9), size: 15),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      value.title,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontFamily: 'medium', fontSize: 13),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.9), size: 16),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Find and book best services'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontFamily: 'bold', fontSize: 24, height: 1.25)),
                                          const SizedBox(height: 16),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
                                            onTap: () => value.onSearch(),
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 16),
                                              decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), boxShadow: [BoxShadow(color: ThemeProvider.blackColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Search salon, spa and barber'.tr, style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 14)),
                                                  const Icon(Icons.search_outlined, color: ThemeProvider.appColor, size: 18)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: value.haveData == true
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Top Categories'.tr, style: const TextStyle(fontSize: 16, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                            TextButton(
                                              onPressed: () => value.onAllCategories(),
                                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                              child: Text('View all'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 12, fontFamily: 'medium')),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (var item in value.categoriesList)
                                              InkWell(
                                                borderRadius: BorderRadius.circular(16),
                                                onTap: () => value.onCategoriesList(item.id as int, item.name.toString()),
                                                child: Container(
                                                  margin: const EdgeInsets.only(right: 16),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(3),
                                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ThemeProvider.borderColor, width: 1)),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(100),
                                                          child: SizedBox.fromSize(
                                                            size: const Size.fromRadius(28),
                                                            child: FadeInImage(
                                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
                                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                              imageErrorBuilder: (context, error, stackTrace) {
                                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                                              },
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 8),
                                                        child: Text(
                                                          (item.name ?? '').length > 15 ? '${(item.name ?? '').substring(0, 15)}...' : (item.name ?? ''),
                                                          style: const TextStyle(fontSize: 11, color: ThemeProvider.textSecondary, fontFamily: 'medium'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                            height: 190,
                                            viewportFraction: 0.80,
                                            initialPage: 0,
                                            enableInfiniteScroll: true,
                                            reverse: false,
                                            autoPlay: true,
                                            autoPlayInterval: const Duration(seconds: 3),
                                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: false,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                          carouselController: _controller,
                                          items: List.generate(
                                            value.bannerList.length,
                                            (index) => GestureDetector(
                                              onTap: () => value.onBanner(value.bannerList[index].value.toString(), value.bannerList[index].type.toString()),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(ThemeProvider.cardRadius), boxShadow: ThemeProvider.cardShadow),
                                                        child: Stack(
                                                          clipBehavior: Clip.none,
                                                          alignment: Alignment.bottomCenter,
                                                          children: [
                                                            SizedBox(
                                                              height: 170,
                                                              width: double.infinity,
                                                              child: FadeInImage(
                                                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.bannerList[index].cover.toString()}'),
                                                                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                                imageErrorBuilder: (context, error, stackTrace) {
                                                                  return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                                                },
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 54,
                                                              width: double.infinity,
                                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  begin: Alignment.topCenter,
                                                                  end: Alignment.bottomCenter,
                                                                  colors: [ThemeProvider.blackColor.withOpacity(0.0), ThemeProvider.blackColor.withOpacity(0.6)],
                                                                ),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    value.bannerList[index].title.toString(),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 14),
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
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Top Specialist'.tr, style: const TextStyle(fontSize: 16, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                          TextButton(
                                            onPressed: () => value.onAllSpecialist(),
                                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                            child: Text('View all'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 12, fontFamily: 'medium')),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (var item in value.individualList)
                                              Padding(
                                                padding: const EdgeInsets.only(right: 16),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () => value.onSpecialist(item.uid as int),
                                                      child: Container(
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0), border: Border.all(width: 2, color: ThemeProvider.appColor)),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(3.0),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(100),
                                                            child: SizedBox.fromSize(
                                                              size: const Size.fromRadius(25),
                                                              child: FadeInImage(
                                                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.userInfo?.cover.toString()}'),
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
                                                    const SizedBox(height: 6),
                                                    Text(item.userInfo?.firstName ?? '', style: const TextStyle(fontFamily: 'semibold', fontSize: 13, color: ThemeProvider.textPrimary)),
                                                    Text(item.userInfo?.lastName ?? '', style: const TextStyle(fontSize: 10, color: ThemeProvider.textSecondary)),
                                                  ],
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Top Salon'.tr, style: const TextStyle(fontSize: 16, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                          TextButton(
                                            onPressed: () => value.onAllOffers(),
                                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                            child: Text('View all'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 12, fontFamily: 'medium')),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: [
                                                for (var item in value.salonList)
                                                  Container(
                                                    width: 250,
                                                    margin: const EdgeInsets.only(right: 12),
                                                    decoration: ThemeProvider.cardDecoration(),
                                                    clipBehavior: Clip.antiAlias,
                                                    child: InkWell(
                                                      onTap: () => value.onServices(item.uid as int),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 110,
                                                            width: 250,
                                                            child: FadeInImage(
                                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
                                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                              imageErrorBuilder: (context, error, stackTrace) {
                                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                                              },
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 250,
                                                            child: Stack(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                              child: Text(item.name.toString(),
                                                                                  overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontFamily: 'semibold', color: ThemeProvider.textPrimary))),
                                                                          Row(
                                                                            children: [
                                                                              const Icon(Icons.star, color: ThemeProvider.orangeColor, size: 16),
                                                                              const SizedBox(width: 4),
                                                                              Text(item.rating.toString(), style: const TextStyle(fontSize: 13, fontFamily: 'medium', color: ThemeProvider.textPrimary))
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 4),
                                                                      Text(
                                                                        (item.address ?? '').length > 15 ? '${(item.address ?? '').substring(0, 27)}...' : (item.address ?? ''),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: const TextStyle(fontSize: 12, color: ThemeProvider.textSecondary),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 0,
                                                                  bottom: 0,
                                                                  child: Container(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                    decoration: const BoxDecoration(
                                                                      color: ThemeProvider.appColor,
                                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(14), bottomRight: Radius.circular(ThemeProvider.cardRadius)),
                                                                    ),
                                                                    child: Text('Book'.tr, style: const TextStyle(fontSize: 11, fontFamily: 'semibold', color: ThemeProvider.whiteColor)),
                                                                  ),
                                                                ),
                                                              ],
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Top Products'.tr, style: const TextStyle(fontSize: 16, fontFamily: 'semibold', color: ThemeProvider.textPrimary)),
                                          TextButton(
                                            onPressed: () => value.onTopProducts(),
                                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                            child: Text(
                                              'View all'.tr,
                                              style: const TextStyle(color: ThemeProvider.appColor, fontSize: 12, fontFamily: 'medium'),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 16),
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            children: List.generate(
                                              value.productsList.length,
                                              (i) {
                                                return GestureDetector(
                                                  onTap: () => value.onProduct(value.productsList[i].id as int),
                                                  child: Container(
                                                    clipBehavior: Clip.antiAlias,
                                                    margin: const EdgeInsets.only(right: 12, bottom: 16),
                                                    width: 155,
                                                    decoration: ThemeProvider.cardDecoration(radius: 16),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 120,
                                                          width: double.infinity,
                                                          child: Stack(
                                                            clipBehavior: Clip.none,
                                                            children: [
                                                              FadeInImage(
                                                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.productsList[i].cover.toString()}'),
                                                                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                                                imageErrorBuilder: (context, error, stackTrace) {
                                                                  return Image.asset('assets/images/notfound.png', width: double.infinity, height: 120, fit: BoxFit.cover);
                                                                },
                                                                width: double.infinity,
                                                                height: 120,
                                                                fit: BoxFit.cover,
                                                              ),
                                                              Positioned(
                                                                top: 8,
                                                                left: 8,
                                                                child: Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                                  decoration: BoxDecoration(color: ThemeProvider.secondaryAppColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                                  child: Text(
                                                                    '${value.productsList[i].discount}% ${'OFF'.tr}',
                                                                    style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 10),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                value.productsList[i].name.toString(),
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(color: ThemeProvider.textPrimary, fontFamily: 'medium', fontSize: 14),
                                                              ),
                                                              const SizedBox(height: 6),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(Icons.star, color: value.productsList[i].rating! >= 1 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                                                  Icon(Icons.star, color: value.productsList[i].rating! >= 2 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                                                  Icon(Icons.star, color: value.productsList[i].rating! >= 3 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                                                  Icon(Icons.star, color: value.productsList[i].rating! >= 4 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                                                  Icon(Icons.star, color: value.productsList[i].rating! >= 5 ? ThemeProvider.orangeColor : ThemeProvider.borderColor, size: 12),
                                                                  const SizedBox(width: 6),
                                                                  Text(
                                                                    value.productsList[i].totalRating.toString(),
                                                                    style: const TextStyle(color: ThemeProvider.textSecondary, fontFamily: 'medium', fontSize: 12),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 6),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    value.currencySide == 'left' ? '${value.currencySymbol}${value.productsList[i].originalPrice}' : '${value.productsList[i].originalPrice}${value.currencySymbol}',
                                                                    style: const TextStyle(decoration: TextDecoration.lineThrough, color: ThemeProvider.textSecondary, fontSize: 12),
                                                                  ),
                                                                  const SizedBox(width: 4),
                                                                  Text(
                                                                    value.currencySide == 'left' ? '${value.currencySymbol}${value.productsList[i].sellPrice}' : '${value.productsList[i].sellPrice}${value.currencySymbol}',
                                                                    style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 12),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 6),
                                                              value.productsList[i].quantity == 0
                                                                  ? SizedBox(
                                                                      width: 100,
                                                                      height: 28,
                                                                      child: ElevatedButton(
                                                                        onPressed: () => value.addToCart(i),
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: ThemeProvider.appColor,
                                                                          shadowColor: ThemeProvider.transparent,
                                                                          foregroundColor: ThemeProvider.whiteColor,
                                                                          elevation: 0,
                                                                          shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeProvider.chipRadius))),
                                                                          padding: const EdgeInsets.all(0),
                                                                        ),
                                                                        child: Text(
                                                                          'ADD'.tr,
                                                                          style: const TextStyle(letterSpacing: 1, fontSize: 12, color: ThemeProvider.whiteColor, fontFamily: 'bold'),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 24,
                                                                              height: 24,
                                                                              child: ElevatedButton(
                                                                                onPressed: () => value.updateProductQuantityRemove(i),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: ThemeProvider.redColor,
                                                                                  shadowColor: ThemeProvider.transparent,
                                                                                  foregroundColor: ThemeProvider.whiteColor,
                                                                                  elevation: 0,
                                                                                  shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                                                                                  padding: const EdgeInsets.all(0),
                                                                                ),
                                                                                child: const Icon(Icons.remove, size: 14),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Text(
                                                                                value.productsList[i].quantity.toString(),
                                                                                style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.textPrimary),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 24,
                                                                              height: 24,
                                                                              child: ElevatedButton(
                                                                                onPressed: () => value.updateProductQuantity(i),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: ThemeProvider.greenColor,
                                                                                  shadowColor: ThemeProvider.transparent,
                                                                                  foregroundColor: ThemeProvider.whiteColor,
                                                                                  elevation: 0,
                                                                                  shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                                                                                  padding: const EdgeInsets.all(0),
                                                                                ),
                                                                                child: const Icon(Icons.add),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 60),
                                      SizedBox(height: 120, width: 120, child: Image.asset("assets/images/no-data.png", fit: BoxFit.cover)),
                                      const SizedBox(height: 24),
                                      Center(child: Text('No Data Found Near You!'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 16, color: ThemeProvider.textPrimary))),
                                      const SizedBox(height: 8),
                                      Center(child: Text('Try changing your location to see nearby salons and services.'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: ThemeProvider.textSecondary))),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
          bottomNavigationBar: Get.find<ServiceCartController>().totalItemsInCart > 0
              ? SizedBox(
                  height: 76,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                    onTap: () => value.onCheckout(),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: ThemeProvider.appColor,
                        borderRadius: BorderRadius.circular(ThemeProvider.cardRadius),
                        boxShadow: [BoxShadow(color: ThemeProvider.appColor.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value.currencySide == 'left'
                                ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
                                : ' ${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
                            style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'medium', fontSize: 13),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Book Services'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'semibold', fontSize: 14)),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, color: ThemeProvider.whiteColor, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
