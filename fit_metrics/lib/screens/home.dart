import 'package:flutter/material.dart';
import 'package:fit_metrics/common/helpers/container_extensions.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:fit_metrics/common/widgets/drawer.dart';
import 'package:fit_metrics/screens/bmi_calculator_screen.dart';
import 'package:fit_metrics/screens/progress_bmi_screen.dart';
import 'package:fit_metrics/screens/recommended_workouts.dart';
import '../services/progress_bmi_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double? currentBmi;
  String? currentCategory;

  @override
  void initState() {
    super.initState();
    _loadBmi();
  }

  void _loadBmi() {
    final bmiService = BMIService();
    setState(() {
      currentBmi = bmiService.getCurrentBMI();
      currentCategory = bmiService.getCurrentCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final List<Map<String, dynamic>> workouts = [
      {
        "title": "Full Body Blast",
        "level": "Beginner",
        "icon": Icons.fitness_center,
        "color": Colors.blue[50],
        "border": Colors.blue[200],
      },
      {
        "title": "Cardio Kickstart",
        "level": "Beginner",
        "icon": Icons.directions_run,
        "color": Colors.blue[50],
        "border": Colors.blue[200],
      },
      {
        "title": "Core Strength",
        "level": "Intermediate",
        "icon": Icons.accessibility_new,
        "color": Colors.orange[50],
        "border": Colors.orange[200],
      },
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const CommonAppBar(),
      drawer: const CommonDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FEATURES
            context.styledContainer(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        
                        Icons.calculate,
                       
                        size: 25,
                       
                        color: colorScheme.primary,
                      ,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'BMI Calculator',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/bmi_calculator_screen");
                      },
                      style: context.styledElevatedButton().style,
                      child: const Text('Calculate BMI'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // PROGRESS CHART
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.show_chart),
                        SizedBox(width: 8),
                        Text(
                          "Progress Tracker",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Progress Tracker",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Current BMI: ${currentBmi != null ? currentBmi!.toStringAsFixed(1) + (currentCategory != null ? " ($currentCategory)" : "") : "Not calculated"}",
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/progress_tracker');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: const Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.green,
                                size: 28,
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Click to view detailed progress",
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // RECOMMENDED WORKOUTS
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recommended Workouts",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: workouts.map((w) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: w["color"],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: w["border"]),
                          ),
                          child: Row(
                            children: [
                              Icon(w["icon"], size: 20, color: Colors.black54),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    w["title"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    w["level"],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/recommended_workouts');
                        },
                        style: context.styledElevatedButton().style,
                        child: Text("View All Workouts"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
