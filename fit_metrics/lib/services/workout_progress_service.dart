import 'package:shared_preferences/shared_preferences.dart';

class WorkoutProgressService {
  static const _completedWorkoutsKey = 'completed_workouts';

  // Get all completed workouts as a list of workout IDs
  Future<List<String>> getCompletedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedWorkoutsKey) ?? [];
  }

  // Mark a specific workout as completed
  Future<void> markWorkoutCompleted(String workoutId) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList(_completedWorkoutsKey) ?? [];
    if (!completed.contains(workoutId)) {
      completed.add(workoutId);
      await prefs.setStringList(_completedWorkoutsKey, completed);
    }
  }

  // Clear all progress (optional - for debugging or reset)
  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedWorkoutsKey);
  }

  // Calculate percentage progress based on total workouts
  Future<double> getProgressPercent(List<String> allWorkoutIds) async {
    final completed = await getCompletedWorkouts();
    if (allWorkoutIds.isEmpty) return 0;
    final completedCount = allWorkoutIds
        .where((id) => completed.contains(id))
        .length;
    return completedCount / allWorkoutIds.length;
  }

  // Check if a specific workout is completed
  Future<bool> isWorkoutCompleted(String workoutId) async {
    final completed = await getCompletedWorkouts();
    return completed.contains(workoutId);
  }
}
