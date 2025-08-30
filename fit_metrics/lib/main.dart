import 'package:flutter/material.dart';
import 'screens/bmi_calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 20, 80, 240), // AppBar & primary buttons
          onPrimary: Colors.white, // Text/icons on primary
          secondary: Color.fromARGB(255, 20, 80, 240),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white, // Cards & containers
          onSurface: Colors.black, // Text/icons on surface
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFFF2F4F7), // Light gray background for inputs
        ),
      ),
      home: const BMICalculatorScreen(),
    );
  }
}
