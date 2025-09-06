import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fit_metrics/common/helpers/container_extensions.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';
import '../services/progress_bmi_service.dart';
import '../widgets/bmi_result_box.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  double? _bmi;
  String? _category;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  String? _numberValidator(String? value, {required String label}) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    final parsed = double.tryParse(value);
    if (parsed == null) return 'Enter a valid number';
    if (parsed <= 0) return '$label must be > 0';
    if (label == 'Height (cm)' && parsed > 300) {
      return 'Please check your height';
    }
    if (label == 'Weight (kg)' && parsed > 500) {
      return 'Please check your weight';
    }
    return null;
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final h = double.parse(_heightController.text.trim());
    final w = double.parse(_weightController.text.trim());

    final result = BMICalculator.calculate(heightCm: h, weightKg: w);

    setState(() {
      _bmi = result.bmi;
      _category = result.category;
    });

    final bmiJson = result.toJson();

    // Save height, weight, BMI, and category in the service
    final bmiService = BMIService();
    bmiService.saveBMI(bmiJson, targetBmi: 22.0, height: h, weight: w);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: CommonAppBar(icon: Icons.calculate, title: "BMI Calculator"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              context.styledCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Calculate Your BMI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Height (cm)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              _numberValidator(v, label: 'Height (cm)'),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              _numberValidator(v, label: 'Weight (kg)'),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _calculate,
                            style: context.styledElevatedButton().style,
                            child: const Text('Calculate BMI'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BMICalculatorResultBox(bmi: _bmi, category: _category),
            ],
          ),
        ),
      ),
    );
  }
}

class BMICalculator {
  final double bmi;
  final String category;

  const BMICalculator._(this.bmi, this.category);

  static BMICalculator calculate({
    required double heightCm,
    required double weightKg,
  }) {
    final meters = heightCm / 100.0;
    final bmi = weightKg / (meters * meters);

    String category;
    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25) {
      category = 'Normal weight';
    } else if (bmi < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    return BMICalculator._(bmi, category);
  }

  Map<String, dynamic> toJson() {
    return {'bmi': bmi, 'category': category};
  }
}
