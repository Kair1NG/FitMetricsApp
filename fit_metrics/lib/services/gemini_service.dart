import 'dart:convert';
import 'package:flutter/foundation.dart'; // Added for debugPrint
import 'package:google_generative_ai/google_generative_ai.dart';
import '../services/workout_data.dart'; // Added for getExerciseImagePath

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
    : _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

  Future<Map<String, dynamic>> getWorkoutRecommendations(double bmi) async {
    final planTitlesAndDescriptions = allWorkoutPlans
        .map((p) => '${p["title"]}: ${p["description"]}')
        .join('\n');

    final prompt =
        '''
The user has a BMI of $bmi.
Here are the available workout plans (title and description):

$planTitlesAndDescriptions

Based on the user's BMI, recommend two plans by title that best fit their needs.
Respond ONLY with the titles of the recommended plans, separated by a comma.
At the top, include this message (with the user's BMI filled in): 
"Because your BMI is $bmi, we have decided on a workout that fits your weight class and will get you in tiptop shape! Here are a selection of two possible workouts. Please choose one of them to begin the workout plan!"
''';

    final response = await _model.generateContent([Content.text(prompt)]);

    final text = response.text ?? "";
    debugPrint("Gemini raw response:\n$text"); // Replaced print

    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    String? messageLine;
    String? titlesLine;

    for (var line in lines) {
      if (line.toLowerCase().contains("bmi")) {
        messageLine = line;
      } else if (line.contains(',') && !line.contains(':')) {
        titlesLine = line;
      }
    }

    final titles = titlesLine != null
        ? titlesLine.split(',').map((t) => t.trim()).toList()
        : [];

    return {
      "message":
          messageLine ??
          "Because your BMI is $bmi, here are two workouts chosen to fit your weight class.",
      "titles": titles.isNotEmpty
          ? titles
          : ["Full Body Blast", "Core Strength"],
    };
  }

  // New method: Generate workout steps for a specific plan title using Gemini
  Future<List<Map<String, dynamic>>> getWorkoutSteps(String title) async {
    // Find the plan details
    final plan = allWorkoutPlans.firstWhere(
      (p) => p['title'] == title,
      orElse: () => throw ArgumentError('Workout plan "$title" not found'),
    );

    final description = plan['description'];
    final level = plan['level'];
    final exercises = (plan['exercises'] as List).join(', ');

    final prompt =
        '''
Generate a detailed workout sequence for the following plan:

Title: $title
Level: $level
Description: $description
Suggested exercises: $exercises

Create 4-6 workout steps, alternating between "workout" and "rest" (start and end with workout).
Include 1-2 rest steps between workouts.
For workout steps: Use reps (e.g., 10-20) for strength exercises or duration (seconds) for holds/cardio. Estimate calories burned per step (5-20). Include target muscle groups.
For rest steps: Use duration (30-60 seconds).

Respond ONLY with a valid JSON array of step objects. No other text or explanations.
Each object must have:
- "type": "workout" or "rest" (string)
- "name": exercise name (string) or "Rest" (for rest)
- "reps": int (optional, for rep-based workouts)
- "duration": int (optional, seconds; required for rest and time-based workouts)
- "calories": int (required, estimated)
- "target": string (optional, muscle groups for workouts only)

Example JSON:
[
  {"type": "workout", "name": "Squats", "reps": 15, "calories": 12, "target": "Legs"},
  {"type": "rest", "name": "Rest", "duration": 30, "calories": 0},
  {"type": "workout", "name": "Pushups", "reps": 10, "calories": 8, "target": "Chest"}
]
''';

    final response = await _model.generateContent([Content.text(prompt)]);

    final text = response.text ?? "";
    debugPrint("Gemini workout steps response:\n$text"); // Replaced print

    try {
      // Trim and parse as JSON array
      final trimmedText = text.trim();
      if (trimmedText.startsWith('[') && trimmedText.endsWith(']')) {
        final jsonList = jsonDecode(trimmedText) as List<dynamic>;
        List<Map<String, dynamic>> steps = jsonList
            .cast<Map<String, dynamic>>();

        // Integrated: Add imagePath to each step (skip rest)
        for (var step in steps) {
          if (step['type'] != 'rest') {
            // Skip rest
            step['imagePath'] = getExerciseImagePath(step['name'] ?? '');
          } else {
            step['imagePath'] = null; // Explicit for rest
          }
        }

        return steps; // Now includes imagePath for fromJson to pick up
      } else {
        throw FormatException('Response is not a valid JSON array');
      }
    } catch (e) {
      debugPrint('JSON parsing error: $e'); // Replaced print
      // Fallback: Return empty or basic structure; handled in WorkoutService
      rethrow;
    }
  }
}
