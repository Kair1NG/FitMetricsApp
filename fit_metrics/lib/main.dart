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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}
