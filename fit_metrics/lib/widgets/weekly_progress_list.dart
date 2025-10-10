import 'package:flutter/material.dart';
import '../services/progress_entry.dart';

class WeeklyProgressList extends StatelessWidget {
  final List<ProgressEntry> entries;

  const WeeklyProgressList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries.map((entry) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              'BMI: ${entry.bmi.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Weight: ${entry.weight.toStringAsFixed(1)} kg',
            ),
            leading: const Icon(Icons.show_chart, color: Colors.blue),
          ),
        );
      }).toList(),
    );
  }
}


