import 'package:fit_metrics/common/helpers/container_extensions.dart';
import 'package:flutter/material.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';

class WorkoutLibraryScreen extends StatelessWidget {
  const WorkoutLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CommonAppBar(icon: Icons.person, title: "Recommended Workouts"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            WorkoutCard(
              title: "Full Body Blast",
              level: "Beginner",
              description:
                  "Complete full-body strength workout targeting all major muscle groups.",
              keyExercises: ["Squats", "Push-Ups", "Pull-Ups"],
              icon: Icons.fitness_center,
              color: Colors.blue[50]!,
              borderColor: Colors.blue[200]!,
            ),
            const SizedBox(height: 16),
            WorkoutCard(
              title: "Cardio Kickstart",
              level: "Beginner",
              description:
                  "Low intensity cardio workout to boost heart rate and burn calories.",
              keyExercises: ["Jump Rope", "High Knees", "Jogging"],
              icon: Icons.directions_run,
              color: Colors.blue[50]!,
              borderColor: Colors.blue[200]!,
            ),

            const SizedBox(height: 24),
            WorkoutCard(
              title: "Core Strength",
              level: "Intermediate",
              description:
                  "Focused core strengthening workout to build stability and improve posture.",
              keyExercises: [
                "Planks",
                "Russian Twists",
                "Bicycle Crunches",
                "Dead Bug",
              ],
              icon: Icons.accessibility_new,
              color: Colors.orange[50]!,
              borderColor: Colors.orange[200]!,
            ),
            const SizedBox(height: 16),
            WorkoutCard(
              title: "Upper Body Power",
              level: "Intermediate",
              description:
                  "Intense upper body workout focusing on chest, back, and arms.",
              keyExercises: [
                "Pull-Ups",
                "Bench Press",
                "Tricep Dips",
                "Push-Ups",
              ],
              icon: Icons.sports_gymnastics,
              color: Colors.orange[50]!,
              borderColor: Colors.orange[200]!,
            ),
          ],
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54, size: 28),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  level,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: borderColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: keyExercises
                .map(
                  (exercise) => Chip(
                    label: Text(exercise),
                    backgroundColor: Colors.white,
                    shape: StadiumBorder(side: BorderSide(color: borderColor)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: context.styledElevatedButton().style,
              onPressed: () {},
              child: const Text(
                "Start Workout",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
