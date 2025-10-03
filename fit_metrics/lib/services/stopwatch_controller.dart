import 'dart:async';
import '../common/models/workout_step.dart';

enum Phase { idle, prep, workout, rest, done }

class StopwatchController {
  final List<WorkoutStep> steps;
  final void Function() onTick;
  final void Function() onComplete;

  StopwatchController({
    required this.steps,
    required this.onTick,
    required this.onComplete,
  });

  static const int prepSeconds = 5;
  static const int restExtra = 10;

  Timer? _ticker;
  int currentIndex = 0;
  int remaining = 0;
  int totalTimeSec = 0;
  int totalCalories = 0;
  bool isRunning = false;
  Phase phase = Phase.idle;

  void init({bool autoStartFirst = false}) {
    _setupCurrentStep(autoStartFirst);
  }

  void dispose() {
    _ticker?.cancel();
  }

  void _setupCurrentStep(bool autoStart) {
    _ticker?.cancel();
    final step = steps[currentIndex];

    if (step.isRest) {
      phase = Phase.rest;
      remaining = step.duration ?? 0;
    } else if (step.isTimedWorkout) {
      phase = Phase.prep;
      remaining = prepSeconds;
    } else {
      phase = Phase.idle;
      remaining = 0;
      isRunning = false;
      onTick();
      return;
    }

    isRunning = autoStart;
    if (autoStart) _startLoop();
    onTick();
  }

  void _startLoop() {
    if (_ticker != null && _ticker!.isActive) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!isRunning) return;
      if (remaining > 0) {
        remaining--;
        if (phase == Phase.rest || phase == Phase.workout) totalTimeSec++;
        onTick();
      } else {
        t.cancel();
        _onPhaseComplete();
      }
    });
  }

  void _onPhaseComplete() {
    final step = steps[currentIndex];
    if (phase == Phase.prep) {
      phase = Phase.workout;
      remaining = step.duration ?? 0;
      isRunning = true;
      _startLoop();
      onTick();
      return;
    }

    if (phase == Phase.workout && step.calories != null) {
      totalCalories += step.calories!;
    }

    if (currentIndex < steps.length - 1) {
      currentIndex++;
      _setupCurrentStep(true);
    } else {
      phase = Phase.done;
      onComplete();
    }
  }

  void next() {
    final step = steps[currentIndex];
    if (phase == Phase.idle && step.isRepWorkout) {
      if (step.calories != null) totalCalories += step.calories!;
      if (currentIndex < steps.length - 1) {
        currentIndex++;
        _setupCurrentStep(true);
      } else {
        phase = Phase.done;
        onComplete();
      }
      return;
    }
    _ticker?.cancel();
    _onPhaseComplete();
  }

  void previous() {
    if (currentIndex == 0) return;
    _ticker?.cancel();
    currentIndex--;
    _setupCurrentStep(true);
  }

  void togglePause() {
    if (phase == Phase.idle) return;
    isRunning = !isRunning;
    if (isRunning) {
      _startLoop();
    } else {
      _ticker?.cancel();
    }
    onTick();
  }

  void addExtraRest() {
    if (phase == Phase.rest) {
      remaining += restExtra;
      onTick();
    }
  }
}
