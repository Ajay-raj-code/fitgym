import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SimpleLineGraph extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  const SimpleLineGraph({super.key,required this.data, required this.labels});
  @override
  Widget build(BuildContext context) {
    print(data);
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.white,
          minY: 0,
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.redAccent,
                    strokeWidth: 1,
                  ),
                  FlDotData(show: true),
                );
              }).toList();
            },

            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.redAccent.withAlpha(200),

              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map(
                  (e) {
                    final xIndex = e.x.toInt();
                    final value = e.y.toInt();
                    final dateStr = labels.length > xIndex ? labels[xIndex] : 'Date';
                    return LineTooltipItem("$dateStr\n$value",
                        TextStyle(color: Colors.white));
                  },
                ).toList();
              },
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
              if (event is FlTapUpEvent || event is FlLongPressEnd) {
                if (response != null && response.lineBarSpots != null) {}
              }
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (index) => FlSpot(index.toDouble(), data[index]),
              ),
              isCurved: true,
              color: Colors.redAccent,
              barWidth: 2,
              // shadow: Shadow(color: Colors.redAccent),
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.redAccent.withAlpha(100),
                    Colors.redAccent.shade100.withAlpha(10)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: data.length<4? 1: (data.length / 4).floorToDouble(),
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= labels.length) return Container();
                  return SideTitleWidget(
                    meta: meta,
                    space: 4,
                    child: Text(
                      index < labels.length ? labels[index] : '',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 4,
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(
            show: false,
          ),
        ),
      ),
    );
  }
}
