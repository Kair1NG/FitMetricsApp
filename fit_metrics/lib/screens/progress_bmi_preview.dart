import 'package:flutter/material.dart';
import '../screens/progress_bmi_screen.dart';
import '../services/progress_entry.dart';

void main() {
  runApp(const PreviewApp());
}

class PreviewApp extends StatelessWidget {
  const PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    // sample data for preview
    final List<ProgressEntry> sampleEntries = [
      ProgressEntry(week: 1, bmi: 26.2, weight: 74.0),
      ProgressEntry(week: 2, bmi: 25.8, weight: 73.6),
      ProgressEntry(week: 3, bmi: 25.5, weight: 73.0),
      ProgressEntry(week: 4, bmi: 25.1, weight: 72.6),
      ProgressEntry(week: 5, bmi: 24.8, weight: 72.5),
      ProgressEntry(week: 6, bmi: 24.5, weight: 72.3),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Preview Progress',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProgressBMIScreen(entries: sampleEntries),
    );
  }
}