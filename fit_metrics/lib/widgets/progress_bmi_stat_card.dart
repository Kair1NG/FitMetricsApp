import 'package:flutter/material.dart';

class ProgressBMIStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color overlayColor;
  final Color numberColor;

  const ProgressBMIStatCard({
    super.key,
    required this.label,
    required this.value,
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
              color: overlayColor.withOpacity(0.6), // fixed color
            ),
          ),

          // Main card background (fixed color)
          Positioned.fill(
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: overlayColor.withOpacity(0.2), // subtle transparent background
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: numberColor, // fixed color
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        color: numberColor.withOpacity(0.8), // fixed color
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
