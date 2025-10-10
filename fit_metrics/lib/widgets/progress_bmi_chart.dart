import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/progress_entry.dart';

class ProgressChart extends StatefulWidget {
  final List<ProgressEntry> entries;
  final double goalBMI;

  const ProgressChart({super.key, required this.entries, required this.goalBMI});

  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  int currentPage = 0;
  static const int weeksPerPage = 4;

  @override
  Widget build(BuildContext context) {
    int totalPages = (widget.entries.length / weeksPerPage).ceil();
    int startIndex = currentPage * weeksPerPage;
    int endIndex = (startIndex + weeksPerPage).clamp(0, widget.entries.length);

    List<ProgressEntry> pageEntries = widget.entries.sublist(startIndex, endIndex);

    double minY = widget.entries.map((e) => e.bmi).reduce((a, b) => a < b ? a : b) - 1;
    double maxY = widget.entries.map((e) => e.bmi).reduce((a, b) => a > b ? a : b) + 1;

    // Line segments
    List<LineChartBarData> segments = [];
    for (int i = 0; i < pageEntries.length - 1; i++) {
      double bmi1 = pageEntries[i].bmi;
      double bmi2 = pageEntries[i + 1].bmi;

      double avgDiff = ((bmi1 + bmi2) / 2 - widget.goalBMI).abs();
      double intensity = (avgDiff / widget.goalBMI).clamp(0, 1); 
      Color segmentColor = Color.lerp(Colors.green, Colors.red, intensity)!;

      segments.add(LineChartBarData(
        spots: [
          FlSpot(i.toDouble(), bmi1),
          FlSpot((i + 1).toDouble(), bmi2),
        ],
        isCurved: true,
        color: segmentColor,
        barWidth: 3,
        dotData: FlDotData(show: false),
      ));
    }

    // Dots
    List<LineChartBarData> dotBars = [
      LineChartBarData(
        spots: List.generate(
          pageEntries.length,
          (i) => FlSpot(i.toDouble(), pageEntries[i].bmi),
        ),
        isCurved: true,
        color: Colors.transparent,
        barWidth: 0,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            double diff = (widget.goalBMI - spot.y).abs();
            double intensity = (diff / widget.goalBMI).clamp(0, 1);
            Color dotColor = Color.lerp(Colors.green, Colors.red, intensity)!;
            return FlDotCirclePainter(
              radius: 5,
              color: dotColor,
              strokeWidth: 1,
              strokeColor: Colors.black26,
            );
          },
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (pageEntries.length - 1).toDouble(),
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                horizontalInterval: 1,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.3),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.3),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < pageEntries.length) {
                        return Text(
                          'W${startIndex + index + 1}',
                          style: const TextStyle(fontSize: 12),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [...segments, ...dotBars],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Pagination
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
            ),
            Row(
              children: List.generate(
                totalPages,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == currentPage ? Colors.green : Colors.grey[300],
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: currentPage < totalPages - 1
                  ? () => setState(() => currentPage++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}






