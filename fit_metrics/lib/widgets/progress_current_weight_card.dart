import 'package:flutter/material.dart';

class CurrentWeightCard extends StatelessWidget {
  final double weight;
  final Color numberColor;

  const CurrentWeightCard({
    super.key,
    required this.weight,
    required this.numberColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity, 
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${weight.toStringAsFixed(1)} kg',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: numberColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Current Weight',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: numberColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
