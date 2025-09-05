import 'package:flutter/material.dart';
import '/widgets/progress_bmi_stat_card.dart';
import '/widgets/weekly_progress_list.dart';
import '/widgets/progress_bmi_chart.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';

class ProgressBMIScreen extends StatelessWidget {
  const ProgressBMIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // try
    final double currentBmi = 24.5;
    final double bmiChange = -1.7;
    final double targetBmi = 22.5;
    final List<Map<String, dynamic>> entries = [
      {"week": 6, "bmi": 24.5},
      {"week": 5, "bmi": 24.8},
      {"week": 4, "bmi": 25.1},
      {"week": 3, "bmi": 25.5},
      {"week": 2, "bmi": 25.8},
      {"week": 1, "bmi": 26.2},
    ];

    return Scaffold(
      appBar: const CommonAppBar(
        title: "BMI Progress",
        icon: Icons.show_chart,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: ProgressBMIStatCard(
                    title: "Current BMI",
                    value: currentBmi.toString(),
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: ProgressBMIStatCard(
                    title: "Change",
                    value: bmiChange.toString(),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // the Chart
            ProgressChart(entries: entries),
            const SizedBox(height: 20),

            // Weekly progress list
            WeeklyProgressList(entries: entries),
            const SizedBox(height: 20),

            // Goal
            Center(
              child: Text(
                "Your Goal: $targetBmi",
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
