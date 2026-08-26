import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:owner/app/controller/analytics_controller.dart';
import 'package:owner/app/util/theme.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  State<AnalyticScreen> createState() => _AnalyticScreenState();
}

class _AnalyticScreenState extends State<AnalyticScreen> {
  TooltipBehavior? _tooltipBehavior;
  final ScrollController _scrollControllerAppointments = ScrollController();
  final ScrollController _scrollControllerProducts = ScrollController();

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: false, color: ThemeProvider.blackColor, textStyle: const TextStyle(color: ThemeProvider.whiteColor, fontSize: 12));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnalyticsController>(builder: (value) {
      Map<int, Widget> myTabs = <int, Widget>{
        0: Text("Daily".tr, style: TextStyle(color: value.segmentedControlGroupValue == 0 ? ThemeProvider.whiteColor : ThemeProvider.blackColor, fontFamily: 'medium', fontSize: 13)),
        1: Text("Monthly".tr, style: TextStyle(color: value.segmentedControlGroupValue == 1 ? ThemeProvider.whiteColor : ThemeProvider.blackColor, fontFamily: 'medium', fontSize: 13)),
        2: Text("Yearly".tr, style: TextStyle(color: value.segmentedControlGroupValue == 2 ? ThemeProvider.whiteColor : ThemeProvider.blackColor, fontFamily: 'medium', fontSize: 13)),
      };
      Map<int, Widget> myTabsProducts = <int, Widget>{
        0: Text("Daily".tr, style: TextStyle(color: value.segmentedControlGroupValueProducts == 0 ? ThemeProvider.whiteColor : ThemeProvider.blackColor, fontFamily: 'medium', fontSize: 13)),
        1: Text("Monthly".tr, style: TextStyle(color: value.segmentedControlGroupValueProducts == 1 ? ThemeProvider.whiteColor : ThemeProvider.blackColor, fontFamily: 'medium', fontSize: 13)),
        2: Text("Yearly".tr, style: TextStyle(color: value.segmentedControlGroupValueProducts == 2 ? ThemeProvider.whiteColor : ThemeProvider.blackColor, fontFamily: 'medium', fontSize: 13)),
      };
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: ThemeProvider.surfaceTint,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text('Analyze'.tr, style: ThemeProvider.titleStyle),
            bottom: TabBar(
              unselectedLabelColor: ThemeProvider.whiteColor.withOpacity(0.65),
              labelColor: ThemeProvider.whiteColor,
              indicatorColor: ThemeProvider.whiteColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15),
              unselectedLabelStyle: const TextStyle(fontFamily: 'medium', fontSize: 15),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [Tab(text: 'Appointment'.tr), Tab(text: 'Products Order'.tr)],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                controller: _scrollControllerAppointments,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'Earnings'.tr, subtitle: 'Appointment revenue over time'.tr),
                    const SizedBox(height: 14),
                    _SegmentedNav(groupValue: value.segmentedControlGroupValue, tabs: myTabs, thumbColor: ThemeProvider.appColor, onChanged: (i) => value.updateSegments(i)),
                    const SizedBox(height: 16),
                    if (value.segmentedControlGroupValue == 0)
                      _PeriodBlock(
                        navLabel: value.getName(),
                        onBack: value.backMonth,
                        onNext: value.nextMonth,
                        loading: value.dailyApiCalled != true,
                        chart: _buildChart(value),
                        hasData: value.list.isNotEmpty,
                        total: value.totalPrice,
                        average: value.averagePrice,
                        currencySide: value.currencySide,
                        currencySymbol: value.currencySymbol,
                        columnLabel: 'Day'.tr,
                        countLabel: 'Bookings'.tr,
                        rows: [for (var item in value.list) _TableRowData(item.dayName.toString(), item.count.toString(), item.total)],
                      )
                    else if (value.segmentedControlGroupValue == 1)
                      _PeriodBlock(
                        navLabel: value.currenyYear.toString(),
                        onBack: value.backYear,
                        onNext: value.nextYear,
                        loading: value.monthlyApiCalled != true,
                        chart: _buildChartForMonths(value),
                        hasData: value.monthList.isNotEmpty,
                        total: value.totalPriceMonth,
                        average: value.averagePriceMonth,
                        currencySide: value.currencySide,
                        currencySymbol: value.currencySymbol,
                        columnLabel: 'Months'.tr,
                        countLabel: 'Bookings'.tr,
                        rows: [for (var item in value.monthList) _TableRowData(value.monthsListNames[item.dayName as int], item.count.toString(), item.total)],
                      )
                    else
                      _PeriodBlock(
                        navLabel: null,
                        loading: value.yearlyApiCalled != true,
                        chart: _buildChartForYearly(value),
                        hasData: value.yearlyList.isNotEmpty,
                        total: value.totalPriceYearly,
                        average: value.averagePriceYearly,
                        currencySide: value.currencySide,
                        currencySymbol: value.currencySymbol,
                        columnLabel: 'Months'.tr,
                        countLabel: 'Bookings'.tr,
                        rows: [for (var item in value.yearlyList) _TableRowData(item.dayName.toString(), item.count.toString(), item.total)],
                      ),
                  ],
                ),
              ),
              SingleChildScrollView(
                controller: _scrollControllerProducts,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'Earnings'.tr, subtitle: 'Product order revenue over time'.tr),
                    const SizedBox(height: 14),
                    _SegmentedNav(
                        groupValue: value.segmentedControlGroupValueProducts, tabs: myTabsProducts, thumbColor: ThemeProvider.appColor, onChanged: (i) => value.updateSegmentsProducts(i)),
                    const SizedBox(height: 16),
                    if (value.segmentedControlGroupValueProducts == 0)
                      _PeriodBlock(
                        navLabel: value.getNameProducts(),
                        onBack: value.backMonthProducts,
                        onNext: value.nextMonthProducts,
                        loading: value.dailyApiCalledProducts != true,
                        chart: _buildChartProducts(value),
                        hasData: value.listProducts.isNotEmpty,
                        total: value.totalPriceProducts,
                        average: value.averagePriceProducts,
                        currencySide: value.currencySide,
                        currencySymbol: value.currencySymbol,
                        columnLabel: 'Day'.tr,
                        countLabel: 'Orders'.tr,
                        rows: [for (var item in value.listProducts) _TableRowData(item.dayName.toString(), item.count.toString(), item.total)],
                      )
                    else if (value.segmentedControlGroupValueProducts == 1)
                      _PeriodBlock(
                        navLabel: value.currenyYearProducts.toString(),
                        onBack: value.backYearProducts,
                        onNext: value.nextYearProducts,
                        loading: value.monthlyApiCalledProducts != true,
                        chart: _buildChartForMonthsProducts(value),
                        hasData: value.monthListProducts.isNotEmpty,
                        total: value.totalPriceMonthProducts,
                        average: value.averagePriceMonthProducts,
                        currencySide: value.currencySide,
                        currencySymbol: value.currencySymbol,
                        columnLabel: 'Months'.tr,
                        countLabel: 'Orders'.tr,
                        rows: [for (var item in value.monthListProducts) _TableRowData(value.monthsListNames[item.dayName as int], item.count.toString(), item.total)],
                      )
                    else
                      _PeriodBlock(
                        navLabel: null,
                        loading: value.yearlyApiCalledProducts != true,
                        chart: _buildChartForYearlyProducts(value),
                        hasData: value.yearlyListProducts.isNotEmpty,
                        total: value.totalPriceYearlyProducts,
                        average: value.averagePriceYearlyProducts,
                        currencySide: value.currencySide,
                        currencySymbol: value.currencySymbol,
                        columnLabel: 'Months'.tr,
                        countLabel: 'Orders'.tr,
                        rows: [for (var item in value.yearlyListProducts) _TableRowData(item.dayName.toString(), item.count.toString(), item.total)],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  ChartAxis get _hairlineYAxis => NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(width: 1, color: ThemeProvider.dividerColor),
        labelStyle: const TextStyle(fontSize: 10, color: ThemeProvider.subtleTextColor),
      );

  CategoryAxis get _hairlineXAxis => const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
        labelStyle: TextStyle(fontSize: 10, color: ThemeProvider.subtleTextColor),
      );

  DataLabelSettings get _dataLabelSettings =>
      const DataLabelSettings(isVisible: true, labelAlignment: ChartDataLabelAlignment.top, textStyle: TextStyle(fontSize: 10, color: ThemeProvider.mutedTextColor, fontFamily: 'medium'));

  SfCartesianChart _buildChart(AnalyticsController value) => SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.only(top: 8),
        primaryXAxis: _hairlineXAxis,
        primaryYAxis: _hairlineYAxis,
        series: _getWeekData(value),
        tooltipBehavior: _tooltipBehavior,
      );

  SfCartesianChart _buildChartProducts(AnalyticsController value) => SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.only(top: 8),
        primaryXAxis: _hairlineXAxis,
        primaryYAxis: _hairlineYAxis,
        series: _getWeekDataProducts(value),
        tooltipBehavior: _tooltipBehavior,
      );

  SfCartesianChart _buildChartForMonths(AnalyticsController value) => SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.only(top: 8),
        primaryXAxis: _hairlineXAxis,
        primaryYAxis: _hairlineYAxis,
        series: _getMonthsData(value),
        tooltipBehavior: _tooltipBehavior,
      );

  SfCartesianChart _buildChartForMonthsProducts(AnalyticsController value) => SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.only(top: 8),
        primaryXAxis: _hairlineXAxis,
        primaryYAxis: _hairlineYAxis,
        series: _getMonthsDataProducts(value),
        tooltipBehavior: _tooltipBehavior,
      );

  SfCartesianChart _buildChartForYearly(AnalyticsController value) => SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.only(top: 8),
        primaryXAxis: _hairlineXAxis,
        primaryYAxis: _hairlineYAxis,
        series: _getYearlyData(value),
        tooltipBehavior: _tooltipBehavior,
      );

  SfCartesianChart _buildChartForYearlyProducts(AnalyticsController value) => SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: const EdgeInsets.only(top: 8),
        primaryXAxis: _hairlineXAxis,
        primaryYAxis: _hairlineYAxis,
        series: _getYearlyDataProducts(value),
        tooltipBehavior: _tooltipBehavior,
      );

  List<ColumnSeries<ChartSampleData, String>> _getWeekData(AnalyticsController value) => <ColumnSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[for (var item in value.list) ChartSampleData(x: item.dayName, y: item.total, pointColor: ThemeProvider.appColor)],
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
          width: 0.5,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          dataLabelSettings: _dataLabelSettings,
        )
      ];

  List<ColumnSeries<ChartSampleData, String>> _getWeekDataProducts(AnalyticsController value) => <ColumnSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[for (var item in value.listProducts) ChartSampleData(x: item.dayName, y: item.total, pointColor: ThemeProvider.appColor)],
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
          width: 0.5,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          dataLabelSettings: _dataLabelSettings,
        )
      ];

  List<ColumnSeries<ChartSampleData, String>> _getMonthsData(AnalyticsController value) => <ColumnSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[for (var item in value.monthList) ChartSampleData(x: value.monthsListNames[item.dayName as int], y: item.total, pointColor: ThemeProvider.appColor)],
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
          width: 0.5,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          dataLabelSettings: _dataLabelSettings,
        )
      ];

  List<ColumnSeries<ChartSampleData, String>> _getMonthsDataProducts(AnalyticsController value) => <ColumnSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
            for (var item in value.monthListProducts) ChartSampleData(x: value.monthsListNames[item.dayName as int], y: item.total, pointColor: ThemeProvider.appColor)
          ],
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
          width: 0.5,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          dataLabelSettings: _dataLabelSettings,
        )
      ];

  List<ColumnSeries<ChartSampleData, String>> _getYearlyData(AnalyticsController value) => <ColumnSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[for (var item in value.yearlyList) ChartSampleData(x: item.dayName.toString(), y: item.total, pointColor: ThemeProvider.appColor)],
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
          width: 0.5,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          dataLabelSettings: _dataLabelSettings,
        )
      ];

  List<ColumnSeries<ChartSampleData, String>> _getYearlyDataProducts(AnalyticsController value) => <ColumnSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[for (var item in value.yearlyListProducts) ChartSampleData(x: item.dayName.toString(), y: item.total, pointColor: ThemeProvider.appColor)],
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
          width: 0.5,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          dataLabelSettings: _dataLabelSettings,
        )
      ];
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontFamily: 'bold', color: ThemeProvider.blackColor)),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: ThemeProvider.mutedTextColor)),
      ],
    );
  }
}

class _SegmentedNav extends StatelessWidget {
  const _SegmentedNav({required this.groupValue, required this.tabs, required this.thumbColor, required this.onChanged});

  final int groupValue;
  final Map<int, Widget> tabs;
  final Color thumbColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: ThemeProvider.dividerColor)),
      child: CupertinoSlidingSegmentedControl<int>(
        groupValue: groupValue,
        children: tabs,
        thumbColor: thumbColor,
        backgroundColor: ThemeProvider.transparent,
        onValueChanged: (i) => onChanged(i as int),
      ),
    );
  }
}

class _TableRowData {
  _TableRowData(this.label, this.count, this.total);
  final String label;
  final String count;
  final num? total;
}

class _PeriodBlock extends StatelessWidget {
  const _PeriodBlock({
    required this.loading,
    required this.chart,
    required this.hasData,
    required this.total,
    required this.average,
    required this.currencySide,
    required this.currencySymbol,
    required this.columnLabel,
    required this.countLabel,
    required this.rows,
    this.navLabel,
    this.onBack,
    this.onNext,
  });

  final bool loading;
  final Widget chart;
  final bool hasData;
  final String total;
  final String average;
  final String currencySide;
  final String currencySymbol;
  final String columnLabel;
  final String countLabel;
  final List<_TableRowData> rows;
  final String? navLabel;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  String _statMoney(String amount) => currencySide == 'left' ? '$currencySymbol$amount' : '$amount$currencySymbol';

  String _money(num? amount) => currencySide == 'left' ? '$currencySymbol${amount ?? 0}' : '${amount ?? 0}$currencySymbol';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (navLabel != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(ThemeProvider.chipRadius), border: Border.all(color: ThemeProvider.dividerColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: onBack, icon: const Icon(Icons.chevron_left, color: ThemeProvider.appColor)),
                Text(navLabel!, style: const TextStyle(fontFamily: 'medium', fontSize: 13, color: ThemeProvider.blackColor)),
                IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right, color: ThemeProvider.appColor)),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        Container(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          decoration: ThemeProvider.cardDecoration(),
          child: loading ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: ThemeProvider.appColor))) : chart,
        ),
        if (hasData) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _StatTile(icon: Icons.payments_outlined, label: 'Total'.tr, value: _statMoney(total), color: ThemeProvider.appColor)),
              const SizedBox(width: 12),
              Expanded(child: _StatTile(icon: Icons.show_chart, label: 'Average'.tr, value: _statMoney(average), color: ThemeProvider.mutedTextColor)),
            ],
          ),
          const SizedBox(height: 14),
          _EarningsTable(columnLabel: columnLabel, countLabel: countLabel, rows: rows, money: _money),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value, required this.color});

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: ThemeProvider.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 16, fontFamily: 'bold', color: ThemeProvider.blackColor)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: ThemeProvider.mutedTextColor)),
        ],
      ),
    );
  }
}

class _EarningsTable extends StatelessWidget {
  const _EarningsTable({required this.columnLabel, required this.countLabel, required this.rows, required this.money});

  final String columnLabel;
  final String countLabel;
  final List<_TableRowData> rows;
  final String Function(num?) money;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ThemeProvider.cardDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: ThemeProvider.surfaceTint,
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(columnLabel, style: const TextStyle(fontFamily: 'bold', fontSize: 11, color: ThemeProvider.mutedTextColor))),
                Expanded(child: Text(countLabel, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'bold', fontSize: 11, color: ThemeProvider.mutedTextColor))),
                Expanded(child: Text('Earnings'.tr, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'bold', fontSize: 11, color: ThemeProvider.mutedTextColor))),
              ],
            ),
          ),
          ...List.generate(rows.length, (index) {
            final row = rows[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: index == 0 ? ThemeProvider.transparent : ThemeProvider.dividerColor))),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(row.label, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor))),
                  Expanded(child: Text(row.count, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor))),
                  Expanded(child: Text(money(row.total), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontFamily: 'bold', color: ThemeProvider.appColor))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x, this.y, this.xValue, this.yValue, this.secondSeriesYValue, this.thirdSeriesYValue, this.pointColor, this.size, this.text, this.open, this.close, this.low, this.high, this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
