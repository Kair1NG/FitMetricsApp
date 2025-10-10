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
import 'package:fit_metrics/common/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Reset workout progress every time the app starts
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('progress');
  await prefs.remove('completedWorkouts');
  await prefs.remove('currentWorkoutIndex');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
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
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: Color.fromARGB(255, 60, 120, 255), // Vibrant blue
              onPrimary: Colors.white,
              secondary: Color.fromARGB(255, 80, 140, 220),
              onSecondary: Colors.white,
              error: Colors.red,
              onError: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Color(0xFFE1E1E1),
              tertiary: Color(0xFF9E9E9E),
              surfaceContainerHighest: Color(0xFF2C2C2C),
              onSurfaceVariant: Color(0xFFB0B0B0),
            ),
          ),
          home: Home(),
          routes: {
            '/recommended_workouts': (context) =>
                const WorkoutLibraryScreen.all(),
            '/bmi_calculator_screen': (context) => BMICalculatorScreen(),
            '/profile': (context) => ProfileScreen(),
            '/progress_tracker': (context) => ProgressBMIScreen(),
          },
        );
      },
    );
  }
}
