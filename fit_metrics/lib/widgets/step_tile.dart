import 'package:flutter/material.dart';
import '../common/models/workout_step.dart';

class StepTile extends StatelessWidget {
  final WorkoutStep step; // Data for this workout/rest step
  final bool active; // Highlights the tile if it's the current step

  const StepTile({super.key, required this.step, this.active = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        // Slightly highlight if this step is active
        color: active ? cs.primary.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Circle icon representing the step
          CircleAvatar(
            radius: 20,
            backgroundColor: cs.primary,
            child: Icon(step.icon, size: 18, color: cs.onPrimary),
          ),
          const SizedBox(width: 12),
          // Step name and details (reps or duration)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Show different text depending on step type
                Text(
                  step.isRest
                      ? 'Rest • ${step.duration ?? 0}s'
                      : (step.isRepWorkout
                            ? '${step.reps} reps'
                            : '${step.duration ?? 0}s'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
