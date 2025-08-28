import 'package:fit_metrics/common/widgets/appBar.dart';
import 'package:fit_metrics/services/bmiCalculator.dart';
import 'package:flutter/material.dart';
import '../widgets/bmi_result_box.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  double? _bmiResult;
  String _bmiCategory = "";

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      final bmiData = BMICalculator.calculate(height, weight);
      setState(() {
        _bmiResult = bmiData.bmi;
        _bmiCategory = bmiData.category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(icon: Icons.calculate, title: "BMI Calculator"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateBMI,
                child: const Text('Calculate BMI'),
              ),
              BMICalculatorResultBox(bmi: _bmiResult, category: _bmiCategory),
            ],
          ),
        ),
      ),
    );
  }
}
