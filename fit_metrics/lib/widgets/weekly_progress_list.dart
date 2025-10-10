import 'package:flutter/material.dart';
import '../services/progress_entry.dart';

class WeeklyProgressList extends StatelessWidget {
  final List<ProgressEntry> entries;

  const WeeklyProgressList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: entries.map((entry) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Week ${entry.weekNumber}', // Now using explicit weekNumber
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'BMI: ${entry.bmi.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}


