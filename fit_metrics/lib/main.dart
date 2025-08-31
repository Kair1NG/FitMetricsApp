import 'package:fit_metrics/screens/home.dart';
import 'screens/recommendedworkouts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMetrics',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 20, 80, 240),
          onPrimary: Colors.white,
          secondary: Color.fromARGB(255, 50, 120, 200),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
          tertiary: Colors.grey,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFFF2F4F7),
        ),
      ),
      home: Home(),
       routes: {
        '/recommendedWorkouts': (context) => const WorkoutLibraryScreen(),
      },
    );
  }
}
