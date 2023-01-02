import 'package:charts_flutter/flutter.dart' as charts;

class AdminSeries {
  final String year;
  final int subscribers;
  final charts.Color barColor;

  AdminSeries(
      {
        required this.year,
        required this.subscribers,
        required this.barColor,
      }
      );
}