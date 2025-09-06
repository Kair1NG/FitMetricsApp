import 'package:fit_metrics/common/helpers/tracker_extensions.dart';
import 'package:flutter/material.dart';
import '/widgets/weekly_progress_list.dart';
import '/widgets/progress_bmi_chart.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:fit_metrics/services/progress_bmi_service.dart';

class ProgressBMIScreen extends StatelessWidget {
  const ProgressBMIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bmiService = BMIService();

    final double? currentBmi = bmiService.getCurrentBMI();
    final double? targetBmi = bmiService.getTargetBMI();

    // Get weekly progress directly from service
    final List<Map<String, dynamic>> entries = bmiService.getWeeklyProgress();

    final double bmiChange = (entries.length > 1)
        ? entries.first['bmi'] - entries.last['bmi']
        : 0.0;

    return Scaffold(
      appBar: const CommonAppBar(title: "BMI Progress", icon: Icons.show_chart),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    title: "Current BMI",
                    value: currentBmi?.toStringAsFixed(1) ?? '-',
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: buildStatCard(
                    title: "Change",
                    value: bmiChange.toStringAsFixed(1),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Chart
            ProgressChart(entries: entries),
            const SizedBox(height: 20),

            // Weekly progress list
            WeeklyProgressList(entries: entries),
            const SizedBox(height: 20),

            // Goal
            Center(
              child: Text(
                "Your Goal: ${targetBmi?.toStringAsFixed(1) ?? '-'}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
