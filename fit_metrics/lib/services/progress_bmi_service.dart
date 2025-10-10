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
  int? _age;
  String? _gender;

  void saveBMI(
    Map<String, dynamic> bmiJson, {
    double? targetBmi,
    double? height,
    double? weight,
  }) {
    _currentBmi = double.parse(bmiJson['bmi'].toString());
    _currentBmi = double.parse(_currentBmi!.toStringAsFixed(2));
    _currentCategory = bmiJson['category'];
    _targetBmi = targetBmi ?? _targetBmi;
    _currentHeight = height ?? _currentHeight;
    _currentWeight = weight ?? _currentWeight;

    _weeklyProgress.insert(0, {
      "week": _weeklyProgress.length + 1,
      "bmi": _currentBmi,
    });
  }

  // New methods for profile management
  void saveAge(int age) {
    _age = age;
  }

  void saveGender(String gender) {
    _gender = gender;
  }

  void saveHeight(double height) {
    _currentHeight = height;
  }

  void saveWeight(double weight) {
    _currentWeight = weight;
  }

  void calculateAndSaveBMI() {
    if (_currentHeight != null && _currentWeight != null) {
      final heightInMeters = _currentHeight! / 100;
      final bmi = _currentWeight! / (heightInMeters * heightInMeters);

      final category = _getBMICategory(bmi);

      saveBMI({'bmi': bmi, 'category': category});
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // Existing getters
  double? getCurrentBMI() => _currentBmi;
  String? getCurrentCategory() => _currentCategory;
  double? getTargetBMI() => _targetBmi;
  double? getCurrentHeight() => _currentHeight;
  double? getCurrentWeight() => _currentWeight;
  List<Map<String, dynamic>> getWeeklyProgress() => _weeklyProgress;

  // New getters
  int? getAge() => _age;
  String? getGender() => _gender;
}
