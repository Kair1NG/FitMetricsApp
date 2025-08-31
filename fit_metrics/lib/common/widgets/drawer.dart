import 'package:fit_metrics/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:fit_metrics/screens/bmiCalculatorScreen.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary),
            child: Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: colorScheme.onPrimary,
                  size: 36,
                ),
                SizedBox(width: 12),
                Text(
                  'Fit Metrics',
                  style: TextStyle(
                    fontFamily: 'ShatellSans',
                    color: colorScheme.onPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('BMI Calculator'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BMICalculatorScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Register', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
          ),
          ListTile(
            title: const Text('Recommended Workouts'),
            onTap: () {
              Navigator.pop(context); 
              Navigator.pushNamed(context, '/recommendedWorkouts');
            },
          ),
        ],
      ),
    );
  }
}
