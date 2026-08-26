import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/controller/search_controller.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/env.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppSearchController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          body: DefaultTabController(
            length: 1,
            child: TabBarView(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: ThemeProvider.appColor,
                      floating: true,
                      pinned: true,
                      toolbarHeight: 70,
                      snap: false,
                      elevation: 0,
                      iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
                      automaticallyImplyLeading: false,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Your Location'.tr, style: TextStyle(fontSize: 12, color: ThemeProvider.whiteColor.withOpacity(0.8), fontFamily: 'medium')),
                              InkWell(onTap: () => value.onBack(), child: const Icon(Icons.close_outlined, color: ThemeProvider.whiteColor)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: ThemeProvider.whiteColor, size: 15),
                              const SizedBox(width: 5),
                              Text(value.title.length > 30 ? '${value.title.substring(0, 30)}...' : value.title.toString(), style: const TextStyle(fontSize: 15, fontFamily: 'semibold', color: ThemeProvider.whiteColor)),
                              const SizedBox(width: 5),
                              const Icon(Icons.near_me_outlined, color: ThemeProvider.whiteColor, size: 15),
                            ],
                          ),
                        ],
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(64),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: SizedBox(
                            height: 46,
                            child: TextField(
                              controller: value.searchController,
                              onChanged: value.searchProducts,
                              style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Search For Salon, Services.....'.tr,
                                prefixIcon: const Icon(Icons.search, color: ThemeProvider.textSecondary),
                                hintStyle: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 13),
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
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                value.individualList.isNotEmpty ? _buildTitle('Specialist'.tr) : const SizedBox(),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(
                                      value.individualList.length,
                                      (index) => GestureDetector(
                                        onTap: () => value.onSpecialist(value.individualList[index].uid as int),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
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
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: FadeInImage(
                                                          image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.individualList[index].cover.toString()}'),
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
                                              const SizedBox(height: 8),
                                              Text(value.individualList[index].firstName!, style: const TextStyle(fontFamily: 'semibold', fontSize: 13, color: ThemeProvider.textPrimary)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                value.salonList.isNotEmpty ? _buildTitle('Salons'.tr) : const SizedBox(),
                                Column(
                                  children: List.generate(
                                    value.salonList.length,
                                    (index) => Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: ThemeProvider.cardDecoration(),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(14),
                                            child: SizedBox.fromSize(
                                              size: const Size.fromRadius(40),
                                              child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: FadeInImage(
                                                  image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.salonList[index].cover.toString()}'),
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
                                                      child: Text(value.salonList[index].name!, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'semibold', fontSize: 15, color: ThemeProvider.textPrimary)),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.location_on, size: 14, color: ThemeProvider.textSecondary),
                                                        Text(
                                                          '${value.salonList[index].distance}KM',
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: TextAlign.end,
                                                          style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  value.salonList[index].address!,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.star, color: ThemeProvider.orangeColor, size: 15),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                                          child: Text(value.salonList[index].rating.toString(), style: const TextStyle(color: ThemeProvider.textSecondary, fontSize: 12)),
                                                        ),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: () => value.onServices(value.salonList[index].uid as int),
                                                      child: Container(
                                                        decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                                        child: Text('Book'.tr, style: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 12, fontFamily: 'semibold')),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(txt) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(children: [Text('$txt', style: const TextStyle(fontSize: 16, fontFamily: 'semibold', color: ThemeProvider.textPrimary))]));
  }
}
