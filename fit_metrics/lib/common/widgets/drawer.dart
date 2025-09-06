import 'package:flutter/material.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

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
              Navigator.pushNamed(context, '/bmi_calculator_screen');
            },
          ),
          ListTile(
            title: Text('Register', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
          ListTile(
            title: const Text('Recommended Workouts'),
            onTap: () {
              Navigator.pushNamed(context, '/recommended_workouts');
            },
          ),
          ListTile(
            title: const Text('Progress Tracker'),
            onTap: () {
              Navigator.pushNamed(context, '/progress_tracker');
            },
          ),
        ],
      ),
    );
  }
}
