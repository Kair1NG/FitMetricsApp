class BMICalculator {
  final double bmi;
  final String category;

  const BMICalculator._(this.bmi, this.category);

  static BMICalculator calculate({
    required double heightCm,
    required double weightKg,
  }) {
    final meters = heightCm / 100.0; // Convert cm to meters
    final bmi = weightKg / (meters * meters); // BMI formula

    String category;

    // Determine BMI category
    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25) {
      category = 'Normal weight';
    } else if (bmi < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    // Return an instance using private constructor
    return BMICalculator._(bmi, category);
  }
}
