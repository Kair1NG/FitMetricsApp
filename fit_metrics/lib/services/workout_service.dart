import 'dart:async';
import 'package:flutter/foundation.dart'; // Added for debugPrint
import '../common/models/workout_step.dart';
import 'gemini_service.dart';

class WorkoutService {
  final GeminiService? _geminiService;

  // Optional API key: If not provided, uses dummy data (no Gemini integration)
  WorkoutService({String? apiKey})
    : _geminiService = apiKey != null ? GeminiService(apiKey) : null;

  // Fetch workout steps by ID (title) using Gemini if API key provided, else dummy
  Future<List<WorkoutStep>> fetchWorkoutSteps(String workoutId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // If no Gemini service (no API key), use dummy data
    if (_geminiService == null) {
      debugPrint(
        'No API key provided; using dummy workout steps.',
      ); // Replaced print
      return _getDummySteps();
    }

    try {
      // Call Gemini to generate steps
      final jsonSteps = await _geminiService.getWorkoutSteps(workoutId);
      // Parse to WorkoutStep objects
      return parseFromJsonList(jsonSteps);
    } catch (e) {
      debugPrint(
        'Gemini integration failed: $e; falling back to dummy data.',
      ); // Replaced print
      // Fallback to dummy implementation if integration fails
      return _getDummySteps();
    }
  }

  // Dummy steps (extracted for reuse)
  List<WorkoutStep> _getDummySteps() {
    return [
      const WorkoutStep(
        type: StepType.workout,
        name: 'Pushups',
        reps: 15,
        calories: 12,
        target: 'Chest & Triceps',
      ),
      const WorkoutStep(type: StepType.rest, name: 'Rest', duration: 30),
      const WorkoutStep(
        type: StepType.workout,
        name: 'Plank',
        duration: 20,
        calories: 8,
        target: 'Core',
      ),
      const WorkoutStep(type: StepType.rest, name: 'Rest', duration: 30),
      const WorkoutStep(
        type: StepType.workout,
        name: 'Squats',
        reps: 20,
        calories: 14,
        target: 'Legs & Glutes',
      ),
    ];
  }

  // Helper to parse JSON list to WorkoutStep objects
  List<WorkoutStep> parseFromJsonList(List<dynamic> list) {
    return list.map((e) {
      if (e is Map<String, dynamic>) return WorkoutStep.fromJson(e);
      if (e is Map) return WorkoutStep.fromJson(Map<String, dynamic>.from(e));
      throw Exception('Invalid workout step data');
    }).toList();
  }
}
