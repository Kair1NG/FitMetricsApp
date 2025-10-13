import 'package:flutter/material.dart';
import '../widgets/progress_bmi_chart.dart';
import '../widgets/progress_bmi_stat_card.dart';
import '../widgets/progress_current_weight_card.dart';
import '../widgets/bmi_goal_card.dart';
import '../widgets/weekly_progress_list.dart';
import '../widgets/progress_hover_pop.dart';
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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF7F5FA),
      body: Column(
        children: [
          // Top bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(width: 6),
                      Icon(Icons.show_chart, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'BMI Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Profile icon
                Container(
                  color: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.all(4),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current BMI, Change, Current Weight
                  Row(
                    children: [
                      Expanded(
                        child: ProgressHoverPop(
                          child: ProgressBMIStatCard(
                            label: 'Current BMI',
                            value: currentBmi.toStringAsFixed(1),
                            overlayColor: Colors.green,
                            numberColor: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ProgressHoverPop(
                          child: ProgressBMIStatCard(
                            label: 'Change',
                            value: change.toStringAsFixed(1),
                            overlayColor: change < 0 ? Colors.orange : Colors.blue,
                            numberColor: change < 0 ? Colors.orange : Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ProgressHoverPop(
                          child: CurrentWeightCard(
                            weight: currentWeight,
                            overlayColor: Colors.purple,
                            numberColor: Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // BMI Progress Chart
                  ProgressChart(
                    entries: entries,
                    goalBMI: 22.0,
                  ),
                  const SizedBox(height: 16),

                  // BMI Goal Card
                  ProgressHoverPop(
                    child: BMIGoalCard(
                      label: 'BMI Goal',
                      value: '22.0',
                      icon: Icons.show_chart,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Weekly Progress
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
          ),
        ],
      ),
    );
  }
}

