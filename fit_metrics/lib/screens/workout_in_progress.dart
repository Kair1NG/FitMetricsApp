import 'package:flutter/material.dart';
import '../common/models/workout_step.dart';
import '../services/stopwatch_controller.dart';
import '../services/workout_service.dart';
import '../widgets/step_tile.dart';
import '../common/widgets/app_bar.dart';
import '../common/helpers/container_extensions.dart';
import '../services/workout_data.dart';
import '../services/photo_assets_data.dart';
import 'workout_summary.dart';
import '../services/workout_progress_service.dart';

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
  final _progressService = WorkoutProgressService();
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadSteps();
  }

  Future<void> _loadSteps() async {
    try {
      if (widget.steps != null) {
        _steps = widget.steps!;
      } else if (widget.workoutId != null) {
        _steps = await _workoutService.fetchWorkoutSteps(widget.workoutId!);
      } else {
        _steps = await _workoutService.fetchWorkoutSteps('sample');
      }

      _controller = StopwatchController(
        steps: _steps,
        onTick: () => setState(() {}),
        onComplete: _completeWorkout,
      )..init(autoStartFirst: false);

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _completeWorkout() async {
    // Use workoutId if provided; otherwise fallback to the first step's name as an ID
    final id = widget.workoutId ?? _steps.first.name;
    await _progressService.markWorkoutCompleted(id);

    // Navigate to summary (summary will load progress from WorkoutProgressService)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutSummaryScreen(
          totalTimeSec: _controller?.totalTimeSec ?? 0,
          totalCalories: _controller?.totalCalories ?? 0,
          steps: _steps,
          workoutId: id,
        ),
      ),
    );
  }

  void goToSummary() {
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

  String _formatTime(int sec) =>
      '${(sec ~/ 60).toString().padLeft(2, '0')}:${(sec % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error) {
      return Scaffold(
        appBar: const CommonAppBar(title: 'Workout', icon: Icons.timer),
        body: const Center(child: Text('Failed to load workout')),
      );
    }

    final controller = _controller!;
    final step = _steps[controller.currentIndex];
    final cs = Theme.of(context).colorScheme;
    final progressValue = (controller.currentIndex + 1) / _steps.length;

    final showClock =
        controller.phase == Phase.prep ||
        controller.phase == Phase.workout ||
        controller.phase == Phase.rest;

    final totalForPhase = controller.phase == Phase.prep
        ? StopwatchController.prepSeconds
        : (controller.phase == Phase.workout && step.duration != null
              ? step.duration!
              : controller.phase == Phase.rest
              ? (step.duration ?? 1)
              : 1);

    final circleValue = totalForPhase > 0
        ? controller.remaining / totalForPhase
        : 0.0;

    final imagePath = step.imagePath ?? getExerciseImagePath(step.name);
    final isRestStep = step.isRest;

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
              LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                backgroundColor: cs.tertiary.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(cs.primary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Step ${controller.currentIndex + 1} of ${_steps.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const Spacer(),
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
              context.styledContainer(
                child: Column(
                  children: [
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
                    const SizedBox(height: 12),
                    if (!isRestStep)
                      if (!isRestStep)
                        if (!isRestStep)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio:
                                  16 / 9, // keeps a nice rectangular shape
                              child: Image.asset(
                                imagePath,
                                width: double.infinity,
                                fit: BoxFit
                                    .contain, // ensures whole image is visible
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Image.asset(
                                        PhotoAssetsData.placeholder,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 18),
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
                                backgroundColor: cs.secondary,
                                foregroundColor: cs.onSecondary,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (controller.currentIndex < _steps.length - 1) {
                                controller.next();
                              } else {
                                _completeWorkout();
                              }
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: Text(
                              controller.currentIndex < _steps.length - 1
                                  ? 'Next'
                                  : 'Complete',
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
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: List.generate(
                  _steps.length,
                  (i) => StepTile(
                    step: _steps[i],
                    active: i == controller.currentIndex,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
