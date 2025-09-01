import 'package:flutter/material.dart';
import '/screens/progress_bmi_screen.dart';  
void main() {
  runApp(const PreviewApp());
}

class PreviewApp extends StatelessWidget {
  const PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Preview Progress',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProgressBMIScreen(), 
    );
  }
}