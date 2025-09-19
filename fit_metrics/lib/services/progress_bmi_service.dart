class BMIService {
  static final BMIService _instance = BMIService._internal();
  factory BMIService() => _instance;

  BMIService._internal();

  final List<Map<String, dynamic>> _weeklyProgress = [];
  double? _currentBmi;
  String? _currentCategory;
  double? _targetBmi;

  double? _currentHeight;
  double? _currentWeight;

  void saveBMI(
    Map<String, dynamic> bmiJson, {
    double? targetBmi,
    double? height,
    double? weight,
  }) {
    _currentBmi = bmiJson['bmi'];
    _currentCategory = bmiJson['category'];
    _targetBmi = targetBmi ?? _targetBmi;
    _currentHeight = height ?? _currentHeight;
    _currentWeight = weight ?? _currentWeight;

    _weeklyProgress.insert(0, {
      "week": _weeklyProgress.length + 1,
      "bmi": _currentBmi,
    });
  }

  double? getCurrentBMI() => _currentBmi;
  String? getCurrentCategory() => _currentCategory;
  double? getTargetBMI() => _targetBmi;
  double? getCurrentHeight() => _currentHeight;
  double? getCurrentWeight() => _currentWeight;

  List<Map<String, dynamic>> getWeeklyProgress() => _weeklyProgress;
}
