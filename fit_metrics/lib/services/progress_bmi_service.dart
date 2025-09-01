class BMIService {
  // Only Example, update later
  List<Map<String, dynamic>> getWeeklyProgress() {
    return [
      {"week": 1, "bmi": 25.0},
      {"week": 2, "bmi": 24.8},
      {"week": 3, "bmi": 24.6},
      {"week": 4, "bmi": 24.4},
      {"week": 5, "bmi": 24.3},
      {"week": 6, "bmi": 24.2},
    ];
  }

  double getCurrentBMI() => 24.2;
  double getBMIChange() => -0.8;
  double getTargetBMI() => 22.0;
}
