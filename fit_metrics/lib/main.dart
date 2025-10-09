import 'package:fit_metrics/screens/bmi_calculator_screen.dart';
import 'package:fit_metrics/screens/home.dart';
import 'package:fit_metrics/screens/profile.dart';
import 'package:fit_metrics/screens/progress_bmi.dart';
import 'screens/recommended_workouts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Reset workout progress every time the app starts
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('progress');
  await prefs.remove('completedWorkouts');
  await prefs.remove('currentWorkoutIndex');

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
        '/recommended_workouts': (context) => const WorkoutLibraryScreen.all(),
        '/bmi_calculator_screen': (context) => BMICalculatorScreen(),
        '/profile': (context) => ProfileScreen(),
        '/progress_tracker': (context) => ProgressBMIScreen(),
      },
    );
  }
}
