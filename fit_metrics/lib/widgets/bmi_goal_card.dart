import 'package:flutter/material.dart';

class BMIGoalCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const BMIGoalCard({
    super.key,
    required this.label,
    required this.value,
    this.icon = Icons.show_chart,
  });

  @override
  Widget build(BuildContext context) {
    final numberColor = Colors.white;

    return Center(
      child: SizedBox(
        width: 220, // smaller width
        height: 140, // smaller height
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Transparent "page" layer behind main card
            Positioned.fill(
              top: 6,
              left: 6,
              right: 6,
              bottom: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: numberColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            // Main card
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 36, // bigger than number
                    color: numberColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: numberColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: numberColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
