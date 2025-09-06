import 'package:flutter/material.dart';
import '../services/progress_bmi_service.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';

class RecommendedWorkoutsScreen extends StatelessWidget {
  const RecommendedWorkoutsScreen({super.key});

  List<WorkoutCard> _getWorkoutsForCategory(String? category) {
    switch (category) {
      case 'Underweight':
        return [
          WorkoutCard(
            title: "Strength Builder",
            level: "Beginner",
            description: "Focus on strength training to build healthy mass.",
            keyExercises: ["Squats", "Push-Ups", "Lunges"],
            icon: Icons.fitness_center,
            color: Colors.blue[50]!,
            borderColor: Colors.blue[200]!,
          ),
        ];
      case 'Normal weight':
        return [
          WorkoutCard(
            title: "Maintain & Tone",
            level: "Intermediate",
            description: "Balanced routine to stay fit and strong.",
            keyExercises: ["Jogging", "Planks", "Push-Ups"],
            icon: Icons.accessibility_new,
            color: Colors.green[50]!,
            borderColor: Colors.green[200]!,
          ),
        ];
      case 'Overweight':
      case 'Obese':
        return [
          WorkoutCard(
            title: "Cardio Kickstart",
            level: "Beginner",
            description: "Burn fat with low-impact cardio exercises.",
            keyExercises: ["Jump Rope", "Cycling", "Jogging"],
            icon: Icons.directions_run,
            color: Colors.orange[50]!,
            borderColor: Colors.orange[200]!,
          ),
        ];
      default:
        return [
          WorkoutCard(
            title: "General Fitness",
            level: "Beginner",
            description: "Start with simple routines for overall health.",
            keyExercises: ["Walking", "Stretching", "Yoga"],
            icon: Icons.self_improvement,
            color: Colors.grey[50]!,
            borderColor: Colors.grey[300]!,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bmiService = BMIService();
    final category = bmiService.getCurrentCategory();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CommonAppBar(
        icon: Icons.fitness_center,
        title: "Recommended Workouts",
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: screenHeight * 0.02,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(children: _getWorkoutsForCategory(category)),
        ),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String level;
  final String description;
  final List<String> keyExercises;
  final IconData icon;
  final Color color;
  final Color borderColor;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.level,
    required this.description,
    required this.keyExercises,
    required this.icon,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Colors.black87),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(level, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              "Key Exercises:",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: keyExercises
                  .map(
                    (e) => Chip(
                      label: Text(e),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black26),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
