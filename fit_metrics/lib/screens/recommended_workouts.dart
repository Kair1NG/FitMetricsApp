import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_metrics/services/workout_data.dart';
import 'package:fit_metrics/screens/workout_details.dart';
import 'package:fit_metrics/services/photo_assets_data.dart';
import 'package:fit_metrics/common/helpers/container_extensions.dart';

class WorkoutLibraryScreen extends StatefulWidget {
  final String geminiMessage;
  final List<String> recommendations;

  const WorkoutLibraryScreen({
    super.key,
    required this.geminiMessage,
    required this.recommendations,
  });

  const WorkoutLibraryScreen.all({super.key})
    : geminiMessage = "Explore all available workouts!",
      recommendations = const [];

  @override
  State<WorkoutLibraryScreen> createState() => _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen> {
  String activeFilter = "All";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final recommendedSet = widget.recommendations.toSet();

    List<Map<String, dynamic>> plans = widget.recommendations.isNotEmpty
        ? allWorkoutPlans
              .where((plan) => recommendedSet.contains(plan['title']))
              .toList()
        : allWorkoutPlans;
    if (activeFilter == "Beginner" ||
        activeFilter == "Intermediate" ||
        activeFilter == "Advanced") {
      plans = plans.where((p) => p["level"] == activeFilter).toList();
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Workout Library',
        icon: Icons.fitness_center,
      ),
      body: Column(
        children: [
          if (widget.geminiMessage.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: colorScheme.secondary,
              child: Text(
                widget.geminiMessage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton("All"),
                _buildFilterButton("Beginner"),
                _buildFilterButton("Intermediate"),
                _buildFilterButton("Advanced"),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return _WorkoutCard(plan: plan);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isActive = activeFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? colorScheme.onPrimary : colorScheme.tertiary,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final Map<String, dynamic> plan;

  const _WorkoutCard({required this.plan});

  IconData _getIconForLevel(String level) {
    switch (level) {
      case "Beginner":
        return Icons.star_border;
      case "Intermediate":
        return Icons.star_half;
      case "Advanced":
        return Icons.star;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkoutDetailsScreen(
              title: plan["title"],
              duration: plan["duration"],
              intensity: plan["level"],
              exercises: (plan["exercises"] as List<dynamic>).map((e) {
                return {
                  "name": e,
                  "reps": "15 Reps",
                  "image": PhotoAssetsData.placeholder,
                };
              }).toList(),
            ),
          ),
        );
      },
      child: context.styledCard(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _getIconForLevel(plan["level"]),
                  size: 28,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan["title"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: plan["level"] == "Beginner"
                              ? Colors.green.shade100
                              : plan["level"] == "Intermediate"
                              ? Colors.orange.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          plan["level"],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: plan["level"] == "Beginner"
                                ? Colors.green.shade800
                                : plan["level"] == "Intermediate"
                                ? Colors.orange.shade800
                                : Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan["description"],
              style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.timer, size: 18, color: colorScheme.onSurface),
                const SizedBox(width: 6),
                Text(
                  "${plan["duration"]} min",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.fitness_center,
                  size: 18,
                  color: Colors.grey.shade800,
                ),
                const SizedBox(width: 6),
                Text(
                  plan["equipment"],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: (plan["exercises"] as List<dynamic>)
                  .map(
                    (e) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: plan["borderColor"] ?? Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: context.styledElevatedButton(
                child: const Text("Start Workout"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutDetailsScreen(
                        title: plan["title"],
                        duration: plan["duration"],
                        intensity: plan["level"],
                        exercises: (plan["exercises"] as List<dynamic>).map((
                          e,
                        ) {
                          return {
                            "name": e,
                            "reps": "15 Reps",
                            "image": PhotoAssetsData.placeholder,
                          };
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
