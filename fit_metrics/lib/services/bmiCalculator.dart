class BMICalculator {
  final double bmi;
  final String category;

  BMICalculator._(this.bmi, this.category);

  static BMICalculator calculate(double heightCm, double weightKg) {
    final bmi = weightKg / ((heightCm / 100) * (heightCm / 100));
    String category;

    if (bmi < 18.5) {
      category = "Underweight";
    } else if (bmi < 24.9) {
      category = "Normal weight";
    } else if (bmi < 29.9) {
      category = "Overweight";
    } else {
      category = "Obese";
    }

    return BMICalculator._(bmi, category);
  }
}
