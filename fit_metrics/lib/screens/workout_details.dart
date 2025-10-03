import 'package:flutter/material.dart';
import '../common/models/workout_step.dart';
import '../common/widgets/app_bar.dart';
import 'workout_in_progress.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final String title;
  final int duration;
  final String intensity;
  final List<Map<String, dynamic>> exercises;

  const WorkoutDetailsScreen({
    super.key,
    required this.title,
    required this.duration,
    required this.intensity,
    required this.exercises,
  });

  // Convert raw exercise maps into a list of WorkoutStep objects
  List<WorkoutStep> _createWorkoutSteps() {
    List<WorkoutStep> steps = [];
    for (int i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];
      final name = exercise['name'] as String;
      final repsStr = exercise['reps'] as String? ?? '15 Reps';
      // Extract number from reps string, default to 15 if parsing fails
      final reps =
          int.tryParse(repsStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 15;

      steps.add(
        WorkoutStep(
          type: StepType.workout,
          name: name,
          reps: reps,
          calories: (reps ~/ 5) + 5, // simple calorie estimate
          target: _getTargetForExercise(name),
          icon: Icons.fitness_center,
        ),
      );

      // Insert a 30-second rest after each exercise except the last one
      if (i < exercises.length - 1) {
        steps.add(
          const WorkoutStep(type: StepType.rest, name: 'Rest', duration: 30),
        );
      }
    }
    return steps;
  }

  // Determine target muscle group based on exercise name
  String? _getTargetForExercise(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('squat') || lowerName.contains('leg')) {
      return 'Legs & Glutes';
    }
    if (lowerName.contains('push') || lowerName.contains('chest')) {
      return 'Chest & Triceps';
    }
    if (lowerName.contains('plank') || lowerName.contains('core')) {
      return 'Core';
    }
    return 'Full Body';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final steps = _createWorkoutSteps();

    // Pick a color depending on workout intensity
    final levelColor = intensity == 'Beginner'
        ? Colors.green
        : intensity == 'Intermediate'
        ? Colors.orange
        : Colors.red;

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Workout Details',
        icon: Icons.fitness_center,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workout title container
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Transparent level tag with light green for Beginner
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: intensity == 'Beginner'
                                ? Colors.green.withValues(alpha: 0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: levelColor, width: 1.5),
                          ),
                          child: Text(
                            intensity.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: levelColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // "No Equipment" badge with gradient and shadow
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFB700)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.fitness_center,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                ' NO EQUIPMENT ! ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // List of all exercises with reps
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exercises.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        final reps = exercise['reps'] ?? '';
                        final name = exercise['name'] ?? '';

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withAlpha(77),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                reps,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Bottom panel with Start button and quick stats
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      // Start workout and pass generated steps to WorkoutInProgress screen
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkoutInProgress(steps: steps),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'START',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Display quick workout stats: number of exercises, duration, intensity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _iconWithLabelInBox(
                        Icons.fitness_center,
                        '${exercises.length} Exercises',
                        boxColor: Colors.grey.withAlpha(25),
                        iconColor: Colors.blue,
                        textColor: Colors.black,
                      ),
                      _iconWithLabelInBox(
                        Icons.timer_outlined,
                        '~$duration Minutes',
                        boxColor: Colors.grey.withAlpha(25),
                        iconColor: Colors.green,
                        textColor: Colors.black,
                      ),
                      _iconWithLabelInBox(
                        Icons.local_fire_department_outlined,
                        intensity,
                        boxColor: Colors.grey.withAlpha(25),
                        iconColor: Colors.orange,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for displaying an icon with a label inside a colored box
  Widget _iconWithLabelInBox(
    IconData icon,
    String label, {
    required Color boxColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
