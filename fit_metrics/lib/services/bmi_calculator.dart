class BMICalculator {
  final double bmi;
  final String category;

  const BMICalculator._(this.bmi, this.category);

  static BMICalculator calculate({
    required double heightCm,
    required double weightKg,
  }) {
    final meters = heightCm / 100.0; // Convert cm to meters
    final bmiValue = weightKg / (meters * meters); // BMI formula
    final bmi = double.parse(
      bmiValue.toStringAsFixed(2),
    ); // keep as double with 2 decimals

    String category;

    // Determine BMI category
    if (bmiValue < 18.5) {
      category = 'Underweight';
    } else if (bmiValue < 25) {
      category = 'Normal weight';
    } else if (bmiValue < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    // Return an instance using private constructor
    return BMICalculator._(bmi, category);
  }

  Map<String, dynamic> toJson() {
    return {'bmi': bmi, 'category': category};
  }
}
