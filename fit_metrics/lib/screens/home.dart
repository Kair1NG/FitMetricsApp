import 'package:fit_metrics/common/helpers/container_extensions.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:fit_metrics/common/widgets/drawer.dart';
import 'package:fit_metrics/screens/bmi_calculator_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CommonAppBar(),
      drawer: CommonDrawer(),
      body: Center(
        // This container serves as the main content area
        child: Container(
          alignment: Alignment.center,

          // ALL the features within this column
          child: Column(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BMICalculatorScreen(),
                            ),
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
                child: Column(children: [Text('Feature 3')]),
              ),
              context.styledContainer(
                child: Column(children: [Text('Feature 4')]),
              ),
              context.styledContainer(
                child: Column(children: [Text('Feature 5')]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
