import 'package:flutter/material.dart';
import '../widgets/progress_bmi_stat_card.dart';
import '../widgets/progress_current_weight_card.dart';
import '../widgets/progress_bmi_chart.dart';
import '../widgets/weekly_progress_list.dart';

class ProgressBMIScreen extends StatelessWidget {
  const ProgressBMIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final double currentBmi = 24.5;
    final double bmiChange = -1.7;
    final double targetBmi = 22.5;
    final double currentWeight = 72.3; //independent for now

    final List<Map<String, dynamic>> entries = [
      {"week": 6, "bmi": 24.5, "weight": 72.3},
      {"week": 5, "bmi": 24.8, "weight": 72.8},
      {"week": 4, "bmi": 25.1, "weight": 73.2},
      {"week": 3, "bmi": 25.5, "weight": 73.5},
      {"week": 2, "bmi": 25.8, "weight": 74.0},
      {"week": 1, "bmi": 26.2, "weight": 74.3},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 80, 240),
        title: const Text("BMI Progress"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Current BMI & Change
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

            // Current Weight 
            SizedBox(
              width: double.infinity,
              child: ProgressCurrentWeightCard(weight: currentWeight),
            ),
            const SizedBox(height: 20),

            // BMI Chart
            ProgressChart(entries: entries),
            const SizedBox(height: 20),

            // Weekly Progress List
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
