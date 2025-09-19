import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:fit_metrics/screens/recommended_workouts.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
        );

  Future<Map<String, dynamic>> getWorkoutRecommendations(double bmi) async {
    final planTitlesAndDescriptions = allWorkoutPlans
        .map((p) => '${p["title"]}: ${p["description"]}')
        .join('\n');

    final prompt = '''
        The user has a BMI of $bmi.
        Here are the available workout plans (title and description):

        $planTitlesAndDescriptions

        Based on the user's BMI, recommend two plans by title that best fit their needs.
        Respond ONLY with the titles of the recommended plans, separated by a comma.
        At the top, include this message (with the user's BMI filled in): 
        "Because your BMI is $bmi, we have decided on a workout that fits your weight class and will get you in tiptop shape! Here are a selection of two possible workouts. Please choose one of them to begin the workout plan!"
        ''';

    final response = await _model.generateContent([
      Content.text(prompt),
    ]);

    final text = response.text ?? "";
    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

    String? messageLine;
    String? titlesLine;
    for (var line in lines) {
      if (line.startsWith("Because your BMI")) {
        messageLine = line;
    } else if (line.contains(',') && !line.contains(':')) {
    titlesLine = line;
  }
}
    final titles = titlesLine != null
        ? titlesLine.split(',').map((t) => t.trim()).toList()
        : [];
    return {
      "message": messageLine,
      "titles": titles,
    }; 
  } 
}