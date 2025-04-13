import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticalScreen extends StatelessWidget {
  const StatisticalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê điểm danh'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: bottomTitles,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: _barData,
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> get _barData => [
        _makeGroup(0, 12), // Monday
        _makeGroup(1, 15), // Tuesday
        _makeGroup(2, 10), // Wednesday
        _makeGroup(3, 8), // Thursday
        _makeGroup(4, 16), // Friday
        _makeGroup(5, 6), // Saturday
        _makeGroup(6, 0), // Sunday
      ];

  BarChartGroupData _makeGroup(int x, int y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: Colors.teal,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    final titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return SideTitleWidget(
      space: 8.0,
      meta: meta,
      child: Text(titles[value.toInt()], style: style),
    );
  }
}
