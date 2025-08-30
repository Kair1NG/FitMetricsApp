import 'package:fit_metrics/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMetrics',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 20, 80, 240),
          onPrimary: Colors.white,
          primaryContainer: Color.fromARGB(255, 30, 100, 255),
          onPrimaryContainer: Colors.white,
          secondary: Color.fromARGB(255, 50, 120, 200),
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
          tertiary: Colors.grey,
        ),
      ),
      home: Home(),
    );
  }
}
