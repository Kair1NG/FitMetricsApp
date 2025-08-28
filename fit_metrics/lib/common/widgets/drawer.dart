import 'package:flutter/material.dart';
import 'package:fit_metrics/screens/home.dart';
import 'package:fit_metrics/screens/bmiCalculatorScreen.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('FitMetrics'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
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
        ],
      ),
    );
  }
}
