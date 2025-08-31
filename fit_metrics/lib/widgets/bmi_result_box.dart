import 'package:fit_metrics/common/helpers/container_extensions.dart';
import 'package:flutter/material.dart';

class BMICalculatorResultBox extends StatelessWidget {
  final double? bmi;
  final String? category;

  const BMICalculatorResultBox({
    super.key,
    required this.bmi,
    required this.category,
  });

  // Returns color based on BMI category
  Color _categoryColor(String? c, ColorScheme cs) {
    switch (c) {
      case 'Underweight':
        return Colors.blue;
      case 'Normal weight':
        return Colors.green;
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return cs.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme; // Shortcut for color scheme

    if (bmi == null || category == null) {
      return const SizedBox.shrink(); // Hide if not calculated
    }

    final catColor = _categoryColor(category, cs);

    // Reusable row for each legend category
    Widget legendRow(String label, String range, Color bg, Color fg) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: TextStyle(color: fg)),
            ), // Take remaining width
            Text(
              range,
              style: TextStyle(fontWeight: FontWeight.w600, color: fg),
            ),
          ],
        ),
      );
    }

    return context.styledCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your BMI Result',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                bmi!.toStringAsFixed(1), // 1 decimal place
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: catColor,
                ),
              ),
            ),
            Center(
              child: Text(
                category!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: catColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend rows with transparent backgrounds using withAlpha
            legendRow(
              'Underweight',
              '< 18.5',
              Colors.blue.withAlpha(20),
              Colors.blue.shade700,
            ),
            const SizedBox(height: 8),
            legendRow(
              'Normal weight',
              '18.5 - 24.9',
              Colors.green.withAlpha(20),
              Colors.green.shade700,
            ),
            const SizedBox(height: 8),
            legendRow(
              'Overweight',
              '25 - 29.9',
              Colors.orange.withAlpha(25),
              Colors.orange.shade700,
            ),
            const SizedBox(height: 8),
            legendRow(
              'Obese',
              '≥ 30',
              Colors.red.withAlpha(25),
              Colors.red.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
