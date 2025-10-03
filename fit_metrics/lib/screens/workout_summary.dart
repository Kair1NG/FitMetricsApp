import 'package:flutter/material.dart';
import '../common/models/workout_step.dart';
import '../common/widgets/app_bar.dart';
import '../common/helpers/container_extensions.dart';
import 'workout_in_progress.dart';

class WorkoutSummaryScreen extends StatelessWidget {
  final int totalTimeSec;
  final int totalCalories;
  final List<WorkoutStep> steps;

  const WorkoutSummaryScreen({
    super.key,
    required this.totalTimeSec,
    required this.totalCalories,
    required this.steps,
  });
  // Helper function to format the total time into MM:SS string
  String _formatTime(int sec) =>
      "${(sec ~/ 60).toString().padLeft(2, '0')}:${(sec % 60).toString().padLeft(2, '0')}";
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Filter only the workout steps (vs other step types like rest)
    final workoutsDone = steps.where((s) => s.type == StepType.workout);
    return Scaffold(
      // Custom app bar with check icon indicating workout completion
      appBar: const CommonAppBar(
        title: "Workout Summary",
        icon: Icons.check_circle,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Container showing congratulatory message with icon and styled texts
          context.styledContainer(
            child: Column(
              children: [
                Icon(Icons.fitness_center, size: 46, color: cs.primary),
                const SizedBox(height: 8),
                const Text(
                  "Amazing Job!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "You crushed the workout today! Keep the energy up!",
                  style: TextStyle(color: cs.tertiary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Container displaying total workout time and calories burned side-by-side
          context.styledContainer(
            child: Row(
              children: [
                Flexible(
                  child: ListTile(
                    leading: Icon(Icons.timer, size: 36, color: cs.primary),
                    title: const Text("Total Time"),
                    subtitle: Text(_formatTime(totalTimeSec)),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    leading: Icon(
                      Icons.local_fire_department,
                      size: 36,
                      color: cs.primary,
                    ),
                    title: const Text("Calories"),
                    subtitle: Text("$totalCalories kcal"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Workouts Completed",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Dynamically generate a list of workout steps completed
          ...workoutsDone.map(
            (w) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: context.styledContainer(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cs.primary,
                    child: Icon(w.icon),
                  ),
                  title: Text(w.name),
                  subtitle: Text("Target: ${w.target ?? 'general'}"),
                  trailing: Text(
                    // Display reps if available, otherwise duration
                    w.reps != null ? "${w.reps} reps" : "${w.duration ?? 0}s",
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Row containing two buttons: Restart test and Back to Home
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WorkoutInProgress(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Restart Test"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Back to Home"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
