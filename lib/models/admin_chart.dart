import 'package:flutter/cupertino.dart';
import 'admin_chart_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AdminChart extends StatelessWidget{
  final List<AdminSeries> data;

  AdminChart({required this.data});

  @override
  Widget build(BuildContext context) {

    List<charts.Series<AdminSeries, String>> series
    = [
      charts.Series(
        id: "AdminId",
        data: data,
        domainFn: (AdminSeries series, _) =>
        series.year,
        measureFn: (AdminSeries series, _) =>
        series.subscribers,
        colorFn: (AdminSeries series, _) =>
        series.barColor,
      )
    ];

    return charts.BarChart(series, animate: true);
  }}