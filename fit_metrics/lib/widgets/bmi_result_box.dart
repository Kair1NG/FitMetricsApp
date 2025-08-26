import 'package:flutter/material.dart';

class BMICalculatorResultBox extends StatelessWidget {
  final double? bmi;
  final String category;

  const BMICalculatorResultBox({super.key, this.bmi, this.category = ""});

  @override
  Widget build(BuildContext context) {
    if (bmi == null) return const SizedBox();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Center(child: Text("==============================")),
        const Center(child: Text(" Your BMI Result ")),
        const Center(child: Text("==============================")),
        const SizedBox(height: 10),
        Text(
          bmi!.toStringAsFixed(1),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        Text(
          category,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        const Center(child: Text("==============================")),
        const SizedBox(height: 20),
        const Text(
          "BMI Classification Chart:",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Center(child: Text("------------------------------")),
        const Center(child: Text("🔵 Underweight : < 18.5")),
        const Center(child: Text("🟢 Normal weight : 18.5 – 24.9")),
        const Center(child: Text("🟠 Overweight : 25 – 29.9")),
        const Center(child: Text("🔴 Obese : ≥ 30")),
        const Center(child: Text("------------------------------")),
      ],
    );
  }
}
