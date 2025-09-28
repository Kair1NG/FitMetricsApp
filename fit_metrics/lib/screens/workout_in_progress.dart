import 'package:flutter/material.dart';
import '../common/models/workout_step.dart';
import '../services/stopwatch_controller.dart';
import '../services/workout_service.dart';
import '../widgets/step_tile.dart';
import '../common/widgets/app_bar.dart';
import '../common/helpers/container_extensions.dart';
import 'workout_summary.dart';

class WorkoutInProgress extends StatefulWidget {
  final List<WorkoutStep>? steps;
  final String? workoutId;

  const WorkoutInProgress({super.key, this.steps, this.workoutId});

  @override
  State<WorkoutInProgress> createState() => _WorkoutInProgressState();
}

class _WorkoutInProgressState extends State<WorkoutInProgress> {
  late List<WorkoutStep> _steps;
  StopwatchController? _controller;
  final _workoutService = WorkoutService();
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadSteps(); // Load workout steps on screen start
  }

  Future<void> _loadSteps() async {
    try {
      // Decide where to get the workout steps from
      if (widget.steps != null) {
        _steps = widget.steps!;
      } else if (widget.workoutId != null) {
        _steps = await _workoutService.fetchWorkoutSteps(widget.workoutId!);
      } else {
        _steps = await _workoutService.fetchWorkoutSteps('sample');
      }

      // Initialize the stopwatch controller for timing logic
      _controller = StopwatchController(
        steps: _steps,
        onTick: () => setState(() {}), // Update UI every tick
        onComplete: _goToSummary, // Go to summary when workout is done
      )..init(autoStartFirst: false);

      setState(() => _loading = false);
    } catch (e) {
      // Handle loading errors
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // Clean up controller to prevent memory leaks
    super.dispose();
  }

  void _goToSummary() {
    // Navigate to summary screen when all steps are completed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutSummaryScreen(
          totalTimeSec: _controller?.totalTimeSec ?? 0,
          totalCalories: _controller?.totalCalories ?? 0,
          steps: _steps,
        ),
      ),
    );
  }

  // Format seconds into MM:SS
  String _formatTime(int sec) =>
      '${(sec ~/ 60).toString().padLeft(2, '0')}:${(sec % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    // Loading and error states
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error) {
      return Scaffold(
        appBar: const CommonAppBar(title: 'Workout', icon: Icons.timer),
        body: const Center(child: Text('Failed to load workout')),
      );
    }

    // Main workout UI
    final controller = _controller!;
    final step = _steps[controller.currentIndex];
    final cs = Theme.of(context).colorScheme;
    final progressValue = (controller.currentIndex + 1) / _steps.length;

    // Show clock only for timed phases
    final showClock =
        controller.phase == Phase.prep ||
        controller.phase == Phase.workout ||
        controller.phase == Phase.rest;

    // Determine total time for current phase
    final totalForPhase = controller.phase == Phase.prep
        ? StopwatchController.prepSeconds
        : (controller.phase == Phase.workout && step.duration != null
              ? step.duration!
              : controller.phase == Phase.rest
              ? (step.duration ?? 1)
              : 1);

    // Progress for circular timer
    final circleValue = totalForPhase > 0
        ? controller.remaining / totalForPhase
        : 0.0;

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Workout in Progress',
        icon: Icons.timer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Overall workout progress bar
              LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                backgroundColor: cs.tertiary.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(cs.primary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Current step info
                  Text(
                    'Step ${controller.currentIndex + 1} of ${_steps.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const Spacer(),
                  // Phase indicator (Prep/Workout/Rest/Reps)
                  Text(
                    controller.phase == Phase.idle
                        ? (step.reps != null ? '${step.reps} reps' : '')
                        : controller.phase == Phase.prep
                        ? 'Get Ready'
                        : controller.phase == Phase.workout
                        ? 'Workout'
                        : 'Rest',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Main container showing current exercise details
              context.styledContainer(
                child: Column(
                  children: [
                    // Exercise name and icon
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          child: Icon(step.icon),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              if (step.target != null)
                                Text(
                                  step.target!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.tertiary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Timer or reps display depending on phase
                    if (showClock)
                      SizedBox(
                        height: 220,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Circular countdown timer
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: CircularProgressIndicator(
                                  value: circleValue,
                                  strokeWidth: 14,
                                  backgroundColor: cs.tertiary.withValues(
                                    alpha: 0.18,
                                  ),
                                  valueColor: AlwaysStoppedAnimation(
                                    cs.primary,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.phase == Phase.prep
                                        ? 'Get Ready!'
                                        : controller.phase == Phase.rest
                                        ? 'Catch your Breath!'
                                        : 'Push Hard!',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _formatTime(controller.remaining),
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: cs.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // Display reps if it's a rep-based step
                      Column(
                        children: [
                          Text(
                            '${step.reps ?? 0} reps',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Tap Next when done! Keep going!'),
                        ],
                      ),
                    const SizedBox(height: 18),
                    // Navigation buttons (Previous, Pause/Resume, Next)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.currentIndex > 0
                                ? controller.previous
                                : null,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Previous'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (showClock)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: controller.togglePause,
                              icon: Icon(
                                controller.isRunning
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              label: Text(
                                controller.isRunning ? 'Pause' : 'Resume',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        if (showClock) const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.next,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Next'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Extra rest button shown only during rest phase
                    if (controller.phase == Phase.rest)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.addExtraRest,
                          icon: const Icon(Icons.add_alarm),
                          label: const Text('+10s Rest'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: cs.onPrimary,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Upcoming:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // List of remaining steps
              Column(
                children: List.generate(
                  _steps.length - controller.currentIndex - 1,
                  (i) {
                    final s = _steps[controller.currentIndex + 1 + i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: StepTile(step: s, active: false),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
