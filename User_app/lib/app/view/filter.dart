import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/app/util/theme.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

enum Gender { male, female, other }

class _FilterScreenState extends State<FilterScreen> {
  Gender? _character = Gender.male;
  late RangeValues _currentRangeValues = const RangeValues(40, 80);
  int tabID = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.surfaceTint,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: ThemeProvider.appColor,
            floating: true,
            toolbarHeight: 70,
            pinned: true,
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
                    InkWell(onTap: () => Get.back(), child: Text('Cancle'.tr, style: const TextStyle(fontSize: 15, color: ThemeProvider.whiteColor))),
                    Text('Filters'.tr, style: const TextStyle(fontSize: 16, fontFamily: 'semibold', color: ThemeProvider.whiteColor)),
                    Text('Done'.tr, style: const TextStyle(fontSize: 15, fontFamily: 'semibold', color: ThemeProvider.whiteColor)),
                  ],
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Services'.tr),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        alignment: WrapAlignment.start,
                        children: <Widget>[
                          _buildChip('Hairstyle'.tr, false),
                          _buildChip('Mackup'.tr, false),
                          _buildChip('Hair Styling'.tr, false),
                          _buildChip('Spa'.tr, true),
                          _buildChip('Facial Mackup'.tr, false),
                          _buildChip('Trim & Saving'.tr, false),
                        ],
                      ),
                      _buildTitle('Rating'.tr),
                      const Row(
                        children: [
                          Icon(Icons.star, color: ThemeProvider.orangeColor, size: 28),
                          Icon(Icons.star, color: ThemeProvider.orangeColor, size: 28),
                          Icon(Icons.star, color: ThemeProvider.orangeColor, size: 28),
                          Icon(Icons.star, color: ThemeProvider.orangeColor, size: 28),
                          Icon(Icons.star, color: ThemeProvider.borderColor, size: 28),
                          SizedBox(width: 10),
                          Text('4.0 Star', style: TextStyle(color: ThemeProvider.textSecondary, fontFamily: 'semibold', fontSize: 13)),
                        ],
                      ),
                      _buildTitle('Gender'.tr),
                      Container(
                        decoration: ThemeProvider.cardDecoration(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Male'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 13, color: ThemeProvider.textPrimary)),
                                leading: Radio<Gender>(
                                  value: Gender.male,
                                  activeColor: ThemeProvider.appColor,
                                  groupValue: _character,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Female'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 13, color: ThemeProvider.textPrimary)),
                                leading: Radio<Gender>(
                                  value: Gender.female,
                                  activeColor: ThemeProvider.appColor,
                                  groupValue: _character,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Other'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 13, color: ThemeProvider.textPrimary)),
                                leading: Radio<Gender>(
                                  value: Gender.other,
                                  activeColor: ThemeProvider.appColor,
                                  groupValue: _character,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTitle('Distance'.tr),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: ThemeProvider.appColor,
                          inactiveTrackColor: ThemeProvider.borderColor,
                          thumbColor: ThemeProvider.appColor,
                          overlayColor: ThemeProvider.appColor.withOpacity(0.12),
                          valueIndicatorColor: ThemeProvider.appColor,
                        ),
                        child: RangeSlider(
                          values: _currentRangeValues,
                          max: 100,
                          divisions: 5,
                          activeColor: ThemeProvider.appColor,
                          inactiveColor: ThemeProvider.borderColor,
                          labels: RangeLabels(_currentRangeValues.start.round().toString(), _currentRangeValues.end.round().toString()),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _currentRangeValues = values;
                            });
                          },
                        ),
                      ),
                      _buildTitle('Sort by'.tr),
                      Container(
                        decoration: ThemeProvider.cardDecoration(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Most Popular'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'semibold', fontSize: 14)),
                                  const Icon(Icons.check_circle, color: ThemeProvider.appColor, size: 20),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: ThemeProvider.borderColor),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Text('Cost Low To High'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14))],
                              ),
                            ),
                            const Divider(height: 1, color: ThemeProvider.borderColor),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Text('Cost High To Low'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.textPrimary, fontSize: 14))],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTitle('Price'.tr),
                      _buildSegment(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(txt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('$txt', style: const TextStyle(fontSize: 15, fontFamily: 'semibold', color: ThemeProvider.textPrimary))]),
    );
  }

  Widget _buildChip(txt, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? ThemeProvider.appColor : ThemeProvider.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
        border: Border.all(color: selected ? ThemeProvider.appColor : ThemeProvider.borderColor),
      ),
      child: Text(txt, style: TextStyle(fontSize: 13, fontFamily: 'medium', color: selected ? ThemeProvider.whiteColor : ThemeProvider.textPrimary)),
    );
  }

  Widget _buildSegment() {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: ThemeProvider.surfaceTint, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius)),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
              onTap: () {
                setState(() {
                  tabID = 1;
                });
              },
              child: Container(
                height: 38,
                decoration: segmentDecoration(1),
                child: Center(child: Text('\$', style: segmentText(1))),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
              onTap: () {
                setState(() {
                  tabID = 2;
                });
              },
              child: Container(
                height: 38,
                decoration: segmentDecoration(2),
                child: Center(child: Text('\$\$', style: segmentText(2))),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(ThemeProvider.chipRadius),
              onTap: () {
                setState(() {
                  tabID = 3;
                });
              },
              child: Container(
                height: 38,
                decoration: segmentDecoration(3),
                child: Center(child: Text('\$\$\$', style: segmentText(3))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  segmentDecoration(val) {
    return BoxDecoration(color: tabID == val ? ThemeProvider.appColor : ThemeProvider.transparent, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius));
  }

  segmentText(val) {
    return TextStyle(color: tabID == val ? ThemeProvider.whiteColor : ThemeProvider.textSecondary, fontFamily: 'semibold', fontSize: 13);
  }
}
