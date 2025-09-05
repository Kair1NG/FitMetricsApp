import 'package:fit_metrics/common/helpers/container_extensions.dart';
import 'package:fit_metrics/common/helpers/home_extentions.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:fit_metrics/common/widgets/drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CommonAppBar(),
      drawer: CommonDrawer(),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BMI Calculator
              context.styledContainer(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calculate,
                          size: 25,
                          color: colorScheme.primary,
                        ),
                        SizedBox(width: 16),
                        Text(
                          'BMI Calculator',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/bmi_calculator_screen',
                          );
                        },
                        style: context.styledElevatedButton().style,
                        child: Text('Calculate BMI'),
                      ),
                    ),
                  ],
                ),
              ),
              context.styledContainer(
                child: Column(children: [Text('Feature 2')]),
              ),
              context.styledContainer(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Recommended Workouts',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Column(
                      children: [
                        buildWorkoutCard(
                          context,
                          'Full Body Blast',
                          'Beginner',
                          Icons.fitness_center,
                          Colors.blue[50]!,
                          Colors.blue[200]!,
                        ),
                        SizedBox(height: 10),
                        buildWorkoutCard(
                          context,
                          'Cardio Kickstart',
                          'Beginner',
                          Icons.directions_run,
                          Colors.blue[50]!,
                          Colors.blue[200]!,
                        ),
                        SizedBox(height: 10),
                        buildWorkoutCard(
                          context,
                          'Core Strength',
                          'Intermediate',
                          Icons.directions_run,
                          Colors.orange[50]!,
                          Colors.orange[200]!,
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/recommended_workouts',
                              );
                            },
                            style: context.styledElevatedButton().style,
                            child: Text('View All Workouts'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
