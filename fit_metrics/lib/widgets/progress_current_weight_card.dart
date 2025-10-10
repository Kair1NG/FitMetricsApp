import 'package:flutter/material.dart';

class CurrentWeightCard extends StatelessWidget {
  final double weight;
  final Color overlayColor;
  final Color numberColor;

  const CurrentWeightCard({
    super.key,
    required this.weight,
    required this.overlayColor,
    required this.numberColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 28,
            child: Container(
              color: overlayColor.withOpacity(0.6),
            ),
          ),

          // Main card background (same as overlay)
          Positioned.fill(
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: overlayColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${weight.toStringAsFixed(1)} kg',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: numberColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Current Weight',
                      style: TextStyle(
                        fontSize: 16,
                        color: numberColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

