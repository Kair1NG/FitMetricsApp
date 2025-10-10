import 'package:flutter/material.dart';
import '../common/models/workout_step.dart';
import '../common/widgets/app_bar.dart';
import '../common/helpers/container_extensions.dart';
import 'workout_in_progress.dart';
import '../services/workout_progress_service.dart';
import 'home.dart';

class WorkoutSummaryScreen extends StatefulWidget {
  final int totalTimeSec;
  final int totalCalories;
  final List<WorkoutStep> steps;
  final String? workoutId;

  const WorkoutSummaryScreen({
    super.key,
    required this.totalTimeSec,
    required this.totalCalories,
    required this.steps,
    this.workoutId,
  });

  @override
  State<WorkoutSummaryScreen> createState() => _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends State<WorkoutSummaryScreen> {
  final WorkoutProgressService _progressService = WorkoutProgressService();
  double completionPercentage = 0;
  int completedCount = 0;
  final int totalRecommendedWorkouts =
      4; // keep as before (adjust if you want dynamic)

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed = await _progressService.getCompletedWorkouts();
    setState(() {
      completedCount = completed.length;
      completionPercentage = (completedCount / totalRecommendedWorkouts).clamp(
        0.0,
        1.0,
      );
    });
  }

  String _formatTime(int sec) =>
      "${(sec ~/ 60).toString().padLeft(2, '0')}:${(sec % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final workoutsDone = widget.steps
        .where((s) => s.type == StepType.workout)
        .toList();

    return Scaffold(
      appBar: const CommonAppBar(
        title: "Workout Summary",
        icon: Icons.check_circle,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Motivational header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.fitness_center,
                        size: 46,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Amazing Job!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "You crushed the workout today! Keep the energy up!",
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Dashboard: Total Time & Calories
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: context.styledContainer(
                          child: Column(
                            children: [
                              Icon(Icons.timer, size: 36, color: Colors.blue),
                              const SizedBox(height: 4),
                              const Text(
                                "Total Time",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(_formatTime(widget.totalTimeSec)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: context.styledContainer(
                          child: Column(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 36,
                                color: Colors.orange,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Calories",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${widget.totalCalories} kcal"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Recommended Workouts + progress (right)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left text info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recommended Workouts",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$completedCount of $totalRecommendedWorkouts completed",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Right circular progress
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: completionPercentage,
                              strokeWidth: 8,
                              backgroundColor: Colors.green.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                            Center(
                              child: Text(
                                "${(completionPercentage * 100).round()}%",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Workouts Completed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  height: 250,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2.5,
                        ),
                    itemCount: workoutsDone.length,
                    itemBuilder: (context, index) {
                      final w = workoutsDone[index];
                      return context.styledContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: cs.primary,
                              child: Icon(w.icon, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    w.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Target: ${w.target ?? 'general'}"),
                                ],
                              ),
                            ),
                            Text(
                              w.reps != null
                                  ? "${w.reps} reps"
                                  : "${w.duration ?? 0}s",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Buttons stay fixed at bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutInProgress(
                          steps: widget.steps,
                          workoutId: widget.workoutId,
                        ),
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
                    onPressed: () {
                      // Push a fresh Home so Home.initState runs and reloads progress
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const Home()),
                        (route) => false,
                      );
                    },
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
          ),
        ],
      ),
    );
  }
}
