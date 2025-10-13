import 'package:flutter/material.dart';
import '../screens/progress_bmi_screen.dart';
import '../services/progress_entry.dart';

void main() {
  runApp(const ProgressBMIPreview());
}

class ProgressBMIPreview extends StatelessWidget {
  const ProgressBMIPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProgressEntry> entries = [
      ProgressEntry(weight: 73.0, bmi: 28.0, weekNumber: 1),
      ProgressEntry(weight: 72.0, bmi: 27.5, weekNumber: 2),
      ProgressEntry(weight: 71.0, bmi: 27.0, weekNumber: 3),
      ProgressEntry(weight: 70.0, bmi: 26.0, weekNumber: 4),
      ProgressEntry(weight: 69.5, bmi: 24.5, weekNumber: 5),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 33, 150, 243),
          onPrimary: Colors.white,
          surface: Color(0xFF121212),
          onSurface: Colors.white70,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: ProgressBMIScreen(entries: entries),
    );
  }
}

