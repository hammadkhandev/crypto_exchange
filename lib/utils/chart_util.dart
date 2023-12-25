// import 'package:charts_flutter/flutter.dart';
// import 'package:flutter/material.dart';
//
// //charts_flutter: ^0.12.0
// class ChartUtil {
//   List<Series<TimeSeries, DateTime>> seriesList = [];
//
//   // Widget buildTimeSeriesChart(List<DayWisePriceCount>? dayWisePriceCount) {
//   //   if (dayWisePriceCount != null && dayWisePriceCount.isNotEmpty) {
//   //     var priceDataList = dayWisePriceCount.map((e) => TimeSeries(e.date!, e.avgPrice!)).toList();
//   //     var volumeDataList = dayWisePriceCount.map((e) => TimeSeries(e.date!, e.sumPrice!)).toList();
//   //     seriesList = _createSampleData(priceDataList, volumeDataList);
//   //   }
//   //   return TimeSeriesChart(seriesList, animate: true);
//   // }
//
//   static List<Series<TimeSeries, DateTime>> _createSampleData(List<TimeSeries> dataPrice, List<TimeSeries> dataVolume) {
//     return [
//       Series<TimeSeries, DateTime>(
//         id: 'priceChart',
//         colorFn: (_, __) => MaterialPalette.green.shadeDefault,
//         domainFn: (TimeSeries data, _) => data.time,
//         measureFn: (TimeSeries data, _) => data.value,
//         data: dataPrice,
//       ),
//       Series<TimeSeries, DateTime>(
//         id: 'volumeChart',
//         colorFn: (_, __) => MaterialPalette.purple.shadeDefault,
//         domainFn: (TimeSeries data, _) => data.time,
//         measureFn: (TimeSeries data, _) => data.value,
//         data: dataVolume,
//       )
//     ];
//   }
// }
//
// /// Sample time series data type.
// class TimeSeries {
//   final DateTime time;
//   final double value;
//
//   TimeSeries(this.time, this.value);
// }
//
// // class DateTimeComboLinePointChart {
// //   late final List<charts.Series<dynamic, DateTime>> seriesList;
// //   late final bool animate;
// //
// //   Widget buildChart() {
// //     seriesList = _createSampleData();
// //     return charts.TimeSeriesChart(
// //       seriesList,
// //       animate: true,
// //       //defaultRenderer: charts.LineRendererConfig(),
// //       customSeriesRenderers: [charts.PointRendererConfig(customRendererId: 'customPoint')],
// //       //dateTimeFactory: const charts.LocalDateTimeFactory(),
// //     );
// //   }
// //
// //   /// Create one series with sample hard coded data.
// //   static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
// //
// //     final tableSalesData = [
// //       TimeSeriesSales(DateTime(2017, 9, 19), 10),
// //       TimeSeriesSales(DateTime(2017, 9, 26), 50),
// //       TimeSeriesSales(DateTime(2017, 10, 3), 200),
// //       TimeSeriesSales(DateTime(2017, 10, 10), 150),
// //     ];
// //
// //     final mobileSalesData = [
// //       TimeSeriesSales(DateTime(2017, 9, 19), 10),
// //       TimeSeriesSales(DateTime(2017, 9, 26), 50),
// //       TimeSeriesSales(DateTime(2017, 10, 3), 200),
// //       TimeSeriesSales(DateTime(2017, 10, 10), 150),
// //     ];
// //
// //     return [
// //       charts.Series<TimeSeriesSales, DateTime>(
// //         id: 'Tablet',
// //         colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
// //         domainFn: (TimeSeriesSales sales, _) => sales.time,
// //         measureFn: (TimeSeriesSales sales, _) => sales.sales,
// //         data: tableSalesData,
// //       ),
// //       charts.Series<TimeSeriesSales, DateTime>(
// //           id: 'Mobile',
// //           colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
// //           domainFn: (TimeSeriesSales sales, _) => sales.time,
// //           measureFn: (TimeSeriesSales sales, _) => sales.sales,
// //           data: mobileSalesData)
// //         ..setAttribute(charts.rendererIdKey, 'customPoint'),
// //     ];
// //   }
// // }
// //
// // /// Sample time series data type.
// // class TimeSeriesSales {
// //   final DateTime time;
// //   final int sales;
// //
// //   TimeSeriesSales(this.time, this.sales);
// // }
