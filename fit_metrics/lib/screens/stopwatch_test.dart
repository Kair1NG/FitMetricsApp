import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fit_metrics/common/widgets/app_bar.dart';
import 'package:fit_metrics/common/helpers/container_extensions.dart';

// stopwatch with simple routine steps

class StopwatchTestScreen extends StatefulWidget {
  const StopwatchTestScreen({super.key});

  @override
  State<StopwatchTestScreen> createState() => _StopwatchTestScreenState();
}

class _StopwatchTestScreenState extends State<StopwatchTestScreen> {
  // steps list some are rep based some are time based
  final List<Map<String, dynamic>> _steps = [
    {
      'type': 'workout',
      'name': 'Pushups',
      'reps': 15,
      'calories': 12,
      'target': 'Chest & Triceps',
      'icon': Icons.fitness_center,
    },
    {
      'type': 'rest',
      'name': 'Rest',
      'duration': 30,
      'icon': Icons.self_improvement,
    },
    {
      'type': 'workout',
      'name': 'Plank',
      'duration': 20,
      'calories': 8,
      'target': 'Core',
      'icon': Icons.accessibility_new,
    },
    {
      'type': 'rest',
      'name': 'Rest',
      'duration': 30,
      'icon': Icons.self_improvement,
    },
    {
      'type': 'workout',
      'name': 'Squats',
      'reps': 20,
      'calories': 14,
      'target': 'Legs & Glutes',
      'icon': Icons.fitness_center,
    },
  ];

  // state trackers
  int _currentIndex = 0;
  int _remaining = 0; // seconds left for active phase
  int _totalTimeSec = 0; // total time spent in active steps
  int _totalCalories = 0;
  String _phase = 'idle'; // idle prep workout rest
  Timer? _ticker;
  bool _isRunning = false;

  // constants
  static const int prepSeconds = 5;
  static const int restExtra = 10;

  @override
  void initState() {
    super.initState();
    // set first step no auto start
    _setupCurrentStep(startAutomatically: false);
  }

  @override
  void dispose() {
    // cancel timer to avoid spam after dispose
    _ticker?.cancel();
    super.dispose();
  }

  // set up the current step
  void _setupCurrentStep({bool startAutomatically = true}) {
    _ticker?.cancel();
    final step = _steps[_currentIndex];

    if (step['type'] == 'rest') {
      _phase = 'rest';
      _remaining = (step['duration'] as int);
    } else if (step['type'] == 'workout' && step.containsKey('duration')) {
      // timed workout starts with prep
      _phase = 'prep';
      _remaining = prepSeconds;
    } else {
      // rep based workout user taps next manually
      _phase = 'idle';
      _remaining = 0;
      _isRunning = false;
      setState(() {});
      return;
    }

    _isRunning = startAutomatically;
    if (startAutomatically) {
      _startCountdownLoop();
    }
    setState(() {});
  }

  // main countdown loop
  void _startCountdownLoop() {
    if (_ticker != null && _ticker!.isActive) {
      return; // dont create duplicate timer
    }

    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_isRunning) return;

      setState(() {
        if (_remaining > 0) {
          _remaining--;
          if (_phase == 'rest' || _phase == 'workout') {
            _totalTimeSec++;
          }
        } else {
          t.cancel();
          _onPhaseComplete();
        }
      });
    });
  }

  // when a phase ends naturally
  void _onPhaseComplete() {
    final step = _steps[_currentIndex];

    if (_phase == 'prep') {
      // prep finished now real workout
      _phase = 'workout';
      _remaining = (step['duration'] as int);
      _isRunning = true;
      _startCountdownLoop();
      setState(() {});
      return;
    }

    if (_phase == 'workout' &&
        step['type'] == 'workout' &&
        step.containsKey('calories')) {
      _totalCalories += (step['calories'] as int);
    }

    if (_currentIndex < _steps.length - 1) {
      _currentIndex++;
      _setupCurrentStep(startAutomatically: true);
    } else {
      _goToSummary();
    }
  }

  // when user taps next
  void _onNextPressed() {
    final step = _steps[_currentIndex];

    if (_phase == 'idle' &&
        step['type'] == 'workout' &&
        !step.containsKey('duration')) {
      if (step.containsKey('calories')) {
        _totalCalories += (step['calories'] as int);
      }
      if (_currentIndex < _steps.length - 1) {
        _currentIndex++;
        _setupCurrentStep(startAutomatically: true);
      } else {
        _goToSummary();
      }
      return;
    }

    _ticker?.cancel();
    _onPhaseComplete();
  }

  // go back one step
  void _onPreviousPressed() {
    if (_currentIndex == 0) return;
    _ticker?.cancel();
    _currentIndex--;
    _setupCurrentStep(startAutomatically: true);
  }

  // pause or resume
  void _togglePause() {
    if (_phase == 'idle') return;

    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startCountdownLoop();
      } else {
        _ticker?.cancel();
      }
    });
  }

  // add extra rest time
  void _addExtraRest() {
    if (_phase == 'rest') {
      setState(() {
        _remaining += restExtra;
      });
    }
  }

  // go to summary
  void _goToSummary() {
    _ticker?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _SummaryScreen(
          totalTimeSec: _totalTimeSec,
          totalCalories: _totalCalories,
          steps: _steps,
        ),
      ),
    );
  }

  // helper format seconds to mmss
  String _formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentIndex];
    final colorScheme = Theme.of(context).colorScheme;
    final progressValue = (_currentIndex + 1) / _steps.length;

    final showClock =
        _phase == 'prep' || _phase == 'workout' || _phase == 'rest';

    int totalForPhase = _phase == 'prep'
        ? prepSeconds
        : (_phase == 'workout' && step.containsKey('duration')
              ? (step['duration'] as int)
              : _phase == 'rest'
              ? (step['duration'] as int)
              : 1);

    final circleValue = totalForPhase > 0 ? (_remaining / totalForPhase) : 0.0;

    return Scaffold(
      appBar: const CommonAppBar(title: "Stopwatch Test", icon: Icons.timer),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // progress bar
                      LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 8,
                        backgroundColor: colorScheme.tertiary.withAlpha(
                          (0.12 * 255).round(),
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "Step ${_currentIndex + 1} of ${_steps.length}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _phase == 'idle'
                                ? (step['reps'] != null
                                      ? "${step['reps']} reps"
                                      : "")
                                : _phase == 'prep'
                                ? "Get Ready"
                                : _phase == 'workout'
                                ? "Workout"
                                : "Rest",
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // main card with content
                      context.styledContainer(
                        child: Column(
                          children: [
                            // header name and icon
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  child: Icon(
                                    step['icon'] ?? Icons.fitness_center,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        step['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      if (step['target'] != null)
                                        Text(
                                          step['target'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colorScheme.tertiary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // clock for timed steps or reps for idle
                            if (showClock)
                              SizedBox(
                                height: 220,
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: CircularProgressIndicator(
                                          value: circleValue,
                                          strokeWidth: 14,
                                          backgroundColor: colorScheme.tertiary
                                              .withAlpha((0.18 * 255).round()),
                                          valueColor: AlwaysStoppedAnimation(
                                            colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _phase == 'prep'
                                                ? "Get Ready"
                                                : _phase == 'rest'
                                                ? "Rest"
                                                : "Time Left",
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _formatTime(_remaining),
                                            style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: [
                                  Text(
                                    "${step['reps'] ?? 0} reps",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text("tap next when done"),
                                ],
                              ),

                            const SizedBox(height: 18),

                            // buttons row
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _currentIndex > 0
                                        ? _onPreviousPressed
                                        : null,
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text("Previous"),
                                    style: context.styledElevatedButton().style,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (showClock)
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _togglePause,
                                      icon: Icon(
                                        _isRunning
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                      label: Text(
                                        _isRunning ? "Pause" : "Resume",
                                      ),
                                      style: context
                                          .styledElevatedButton()
                                          .style,
                                    ),
                                  ),
                                if (showClock) const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _onNextPressed,
                                    icon: const Icon(Icons.arrow_forward),
                                    label: const Text("Next"),
                                    style: context.styledElevatedButton().style,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // extra rest button
                            if (_phase == 'rest')
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _addExtraRest,
                                  icon: const Icon(Icons.add_alarm),
                                  label: const Text("+10s Rest"),
                                  style: context.styledElevatedButton().style,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// summary screen
class _SummaryScreen extends StatelessWidget {
  final int totalTimeSec;
  final int totalCalories;
  final List<Map<String, dynamic>> steps;

  const _SummaryScreen({
    required this.totalTimeSec,
    required this.totalCalories,
    required this.steps,
  });

  String _formatTime(int sec) =>
      "${(sec ~/ 60).toString().padLeft(2, '0')}:${(sec % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final workoutsDone = steps.where((s) => s['type'] == 'workout');

    return Scaffold(
      appBar: const CommonAppBar(
        title: "Workout Summary",
        icon: Icons.check_circle,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          context.styledContainer(
            child: Column(
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 46,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 8),
                const Text(
                  "good job",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "you finished the test routine",
                  style: TextStyle(color: colorScheme.tertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          context.styledContainer(
            child: Row(
              children: [
                Flexible(
                  child: ListTile(
                    leading: Icon(
                      Icons.timer,
                      size: 36,
                      color: colorScheme.primary,
                    ),
                    title: const Text("Total Time"),
                    subtitle: Text(_formatTime(totalTimeSec)),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    leading: Icon(
                      Icons.local_fire_department,
                      size: 36,
                      color: colorScheme.primary,
                    ),
                    title: const Text("Calories"),
                    subtitle: Text("$totalCalories kcal"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "workouts done",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...workoutsDone.map(
            (w) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: context.styledContainer(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: Icon(w['icon'] ?? Icons.fitness_center),
                  ),
                  title: Text(w['name']),
                  subtitle: Text("target ${w['target'] ?? 'general'}"),
                  trailing: Text(
                    w['reps'] != null
                        ? "${w['reps']} reps"
                        : "${w['duration']}s",
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StopwatchTestScreen()),
            ),
            style: context.styledElevatedButton().style,
            child: const Text("Restart Test"),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.tertiary,
            ),
            child: const Text("Back to Home"),
          ),
        ],
      ),
    );
  }
}
