import 'package:flutter/material.dart';

// Type of workout step: either an exercise or a rest period
enum StepType { workout, rest }

class WorkoutStep {
  final StepType type; // workout or rest
  final String name; // name of the step
  final int? reps; // number of reps (if rep-based)
  final int? duration; // duration in seconds (if timed or rest)
  final int? calories; // estimated calories burned
  final String? target; // target muscle group
  final IconData icon; // icon to show in the UI

  const WorkoutStep({
    required this.type,
    required this.name,
    this.reps,
    this.duration,
    this.calories,
    this.target,
    this.icon = Icons.fitness_center,
  });

  // Quick checks for step type
  bool get isTimedWorkout => type == StepType.workout && duration != null;
  bool get isRepWorkout => type == StepType.workout && reps != null;
  bool get isRest => type == StepType.rest;

  // Create a WorkoutStep from a Map (e.g. from JSON or database)
  factory WorkoutStep.fromJson(Map<String, dynamic> j) {
    final t = (j['type'] ?? 'workout').toString().toLowerCase();
    return WorkoutStep(
      type: t == 'rest' ? StepType.rest : StepType.workout,
      name: j['name'] ?? 'Unknown',
      reps: j['reps'] is int
          ? j['reps'] as int
          : (j['reps'] != null ? int.tryParse(j['reps'].toString()) : null),
      duration: j['duration'] is int
          ? j['duration'] as int
          : (j['duration'] != null
                ? int.tryParse(j['duration'].toString())
                : null),
      calories: j['calories'] is int
          ? j['calories'] as int
          : (j['calories'] != null
                ? int.tryParse(j['calories'].toString())
                : null),
      target: j['target']?.toString(),
      icon: _parseIcon(j['icon']),
    );
  }

  // Convert back to Map for saving or sending to an API
  Map<String, dynamic> toJson() => {
    'type': type == StepType.rest ? 'rest' : 'workout',
    'name': name,
    'reps': reps,
    'duration': duration,
    'calories': calories,
    'target': target,
  };

  // Placeholder icon parser — customize to handle backend icon names
  static IconData _parseIcon(dynamic value) {
    return Icons.fitness_center;
  }
}
