import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/intro_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';

class _SlideData {
  const _SlideData({required this.image, required this.title, required this.subtitle});
  final String image;
  final String title;
  final String subtitle;
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0;

  final List<_SlideData> slides = [
    _SlideData(image: 'assets/sliders/1.png', title: 'Find Barbershop Nearby !', subtitle: 'Discover top-rated salons and barbershops around you in just a few taps'),
    _SlideData(image: 'assets/sliders/2.png', title: 'Attractive Promotions !', subtitle: 'Grab exclusive deals and seasonal offers from your favourite salons'),
    _SlideData(image: 'assets/sliders/3.png', title: 'Professional Specialist !', subtitle: 'Book verified, experienced stylists and specialists you can trust'),
    _SlideData(image: 'assets/sliders/4.png', title: 'Get Specialist at your door steps !', subtitle: 'Prefer to stay home? Have a specialist arrive at your doorstep instead'),
    _SlideData(image: 'assets/sliders/5.png', title: 'Buy from trusted professional !', subtitle: 'Shop salon-grade beauty and grooming products from verified sellers'),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroController>(
      builder: (value) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(elevation: 0, backgroundColor: ThemeProvider.transparent, title: const Row(mainAxisAlignment: MainAxisAlignment.end), actions: <Widget>[getLanguages()]),
          backgroundColor: ThemeProvider.whiteColor,
          body: _buildBody(),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: currentIndex == 0
                  ? _buildNavRow(leftLabel: 'Skip'.tr, onLeft: () => Get.toNamed(AppRouter.chooseLocationRoutes), rightLabel: 'Next'.tr, onRight: () => _controller.nextPage())
                  : currentIndex == slides.length - 1
                      ? _buildNavRow(leftLabel: 'Previous'.tr, onLeft: () => _controller.previousPage(), rightLabel: 'Get Started'.tr, onRight: () => Get.toNamed(AppRouter.chooseLocationRoutes))
                      : _buildNavRow(leftLabel: 'Previous'.tr, onLeft: () => _controller.previousPage(), rightLabel: 'Next'.tr, onRight: () => _controller.nextPage()),
            ),
          ),
        );
      },
    );
  }

  Widget getLanguages() {
    return PopupMenuButton(
      onSelected: (value) {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: ThemeProvider.appColor.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.translate, color: ThemeProvider.appColor, size: 20),
        ),
      ),
      itemBuilder: (context) => AppConstants.languages
          .map((e) => PopupMenuItem<String>(
              value: e.languageCode.toString(),
              onTap: () {
                var locale = Locale(e.languageCode.toString());
                Get.updateLocale(locale);
                Get.find<IntroController>().saveLanguage(e.languageCode);
              },
              child: Text(e.languageName.toString())))
          .toList(),
    );
  }

  Widget _buildBody() {
    return CarouselSlider(
      options: CarouselOptions(
        onPageChanged: (index, reason) => setState(() => currentIndex = index),
        height: double.infinity,
        viewportFraction: 1.0,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      carouselController: _controller,
      items: slides.map((slide) => Builder(builder: (context) => _buildSlide(slide))).toList(),
    );
  }

  Widget _buildSlide(_SlideData slide) {
    return Column(
      children: [
        const SizedBox(height: 90),
        Expanded(
          flex: 5,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.06)),
                ),
                Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.appColor.withOpacity(0.08)),
                ),
                Image.asset(slide.image, height: 260, fit: BoxFit.contain),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(slide.title.tr, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'bold', color: ThemeProvider.textPrimary, fontSize: 23, height: 1.25)),
                const SizedBox(height: 14),
                Text(slide.subtitle.tr, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'regular', color: ThemeProvider.textSecondary, fontSize: 15, height: 1.5)),
                const SizedBox(height: 24),
                _buildDots(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: slides.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _controller.animateToPage(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: currentIndex == entry.key ? 22.0 : 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: currentIndex == entry.key ? ThemeProvider.appColor : ThemeProvider.borderColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavRow({required String leftLabel, required VoidCallback onLeft, required String rightLabel, required VoidCallback onRight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: ThemeProvider.textSecondary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
          onPressed: onLeft,
          child: Text(leftLabel, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeProvider.appColor,
            foregroundColor: ThemeProvider.whiteColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          ),
          onPressed: onRight,
          child: Text(rightLabel, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.whiteColor)),
        ),
      ],
    );
  }
}

contentButtonStyle1() {
  return const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: ThemeProvider.blackColor);
}

contentButtonStyle2() {
  return const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: ThemeProvider.appColor);
}

contentButtonStyle3() {
  return const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: ThemeProvider.redColor);
}
