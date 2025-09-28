import 'package:fit_metrics/common/helpers/container_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:fit_metrics/services/bmi_calculator.dart';
import '../widgets/bmi_result_box.dart';
import '../services/gemini_service.dart';
import 'recommended_workouts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final GeminiService _gemini = GeminiService(
    dotenv.env['GEMINI_API_KEY'] ?? '',
    );

  double? _bmi;
  String? _category;
  bool _loading = false;

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

  void _calculate() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      print("❌ Validation failed");
      return;
    }

    final h = double.parse(_heightController.text.trim());
    final w = double.parse(_weightController.text.trim());
    final result = BMICalculator.calculate(heightCm: h, weightKg: w);

    setState(() {
      _bmi = result.bmi;
      _category = result.category;
      _loading = true;
    });

    print("✅ BMI calculated: $_bmi ($_category)");

    Map<String, dynamic> recs;

    try {
      recs = await _gemini.getWorkoutRecommendations(_bmi!);
      print("✅ Gemini returned: $recs");
    } catch (e) {
      print("❌ Gemini error: $e");

      recs = {
        "message":
            "Because your BMI is $_bmi, here are default workouts while Gemini is unavailable.",
        "titles": ["Full Body Blast", "Core Strength"],
      };
    }

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _loading = false;
    });

    if (!mounted) return;

    final String geminiMessage = recs["message"] as String;
    final List<String> titles = List<String>.from(recs["titles"] ?? []);

    print("✅ Navigating with message: $geminiMessage");
    print("✅ Navigating with titles: $titles");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutLibraryScreen(
          recommendations: titles,
          geminiMessage: geminiMessage,
        ),
      ),
    );

    print("✅ Navigation pushed!");
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: CommonAppBar(icon: Icons.calculate, title: "BMI Calculator"),
      body: Stack(
        children: [
          Padding(
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

          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
