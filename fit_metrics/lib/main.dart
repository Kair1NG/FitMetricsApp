import 'package:flutter/material.dart';
import 'package:fit_metrics/screens/bmi_calculator_screen.dart';
import 'package:fit_metrics/screens/home.dart';
import 'package:fit_metrics/screens/profile.dart';
import 'package:fit_metrics/screens/progress_bmi_screen.dart';
import 'package:fit_metrics/screens/recommended_workouts.dart';
import 'package:fit_metrics/screens/stopwatch_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMetrics',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(200, 20, 70, 240),
          onPrimary: Colors.white,
          secondary: Color.fromARGB(255, 50, 120, 200),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
          tertiary: Colors.grey,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFFF2F4F7),
        ),
      ),
      home: const Home(),
      routes: {
        '/recommended_workouts': (context) => const RecommendedWorkoutsScreen(),
        '/bmi_calculator_screen': (context) => const BMICalculatorScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/progress_tracker': (context) => const ProgressBMIScreen(),
        '/stopwatch': (context) => const StopwatchTestScreen(),
      },
    );
  }
}
