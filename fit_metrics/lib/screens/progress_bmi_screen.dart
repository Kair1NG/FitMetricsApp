import 'package:flutter/material.dart';
import '../widgets/progress_bmi_chart.dart';
import '../widgets/weekly_progress_list.dart';
import '../widgets/progress_bmi_stat_card.dart';
import '../widgets/progress_current_weight_card.dart';
import '../widgets/bmi_goal_card.dart';
import '../services/progress_entry.dart';

class ProgressBMIScreen extends StatelessWidget {
  final List<ProgressEntry> entries;

  const ProgressBMIScreen({super.key, required this.entries});

  double getCurrentBMI() => entries.last.bmi;
  double getCurrentWeight() => entries.last.weight;

  double getChange() {
    if (entries.length < 2) return 0.0;
    return entries.last.bmi - entries.first.bmi;
  }

  @override
  Widget build(BuildContext context) {
    final currentBmi = getCurrentBMI();
    final change = getChange();
    final currentWeight = getCurrentWeight();
    const double goalBMI = 22.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FA),
      // ---------------- Persistent Top Bar ----------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        title: const Text(
          'BMI Progress',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Stat Cards ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ProgressBMIStatCard(
                    label: 'Current BMI',
                    value: currentBmi.toStringAsFixed(1),
                    numberColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ProgressBMIStatCard(
                    label: 'Change',
                    value: change.toStringAsFixed(1),
                    numberColor: change < 0 ? Colors.orange : Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ---------------- Current Weight ----------------
            CurrentWeightCard(
              weight: currentWeight,
              numberColor: Colors.purple,
            ),

            const SizedBox(height: 20),

            // ---------------- BMI Progress Chart ----------------
            ProgressChart(
              entries: entries,
              goalBMI: goalBMI,
            ),

            const SizedBox(height: 20),

            // ---------------- BMI Goal Card ----------------
            BMIGoalCard(
              label: 'BMI Goal',
              value: goalBMI.toStringAsFixed(1),
            ),

            const SizedBox(height: 20),

            // ---------------- Weekly Progress List ----------------
            const Text(
              'Weekly Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            WeeklyProgressList(entries: entries),
          ],
        ),
      ),
    );
  }
}
