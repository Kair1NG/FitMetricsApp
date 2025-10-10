import 'photo_assets_data.dart';

final List<Map<String, dynamic>> allWorkoutPlans = [
  {
    "title": "Full Body Blast",
    "level": "Beginner",
    "description":
        "Complete full-body strength workout targeting all major muscle groups.",
    "duration": 30,
    "equipment": "Bodyweight",
    "exercises": ["Squats", "Push-Ups", "Pull-Ups"],
  },
  {
    "title": "Cardio Kickstart",
    "level": "Beginner",
    "description":
        "Low intensity cardio workout to boost heart rate and burn calories.",
    "duration": 20,
    "equipment": "None",
    "exercises": ["Jump Rope", "High Knees", "Jogging"],
  },
  {
    "title": "Core Strength",
    "level": "Intermediate",
    "description":
        "Focused core strengthening workout to build stability and improve posture.",
    "duration": 25,
    "equipment": "Mat",
    "exercises": ["Planks", "Russian Twists", "Bicycle Crunches", "Dead Bug"],
  },
  {
    "title": "Upper Body Power",
    "level": "Intermediate",
    "description":
        "Intense upper body workout focusing on chest, back, and arms.",
    "duration": 40,
    "equipment": "Dumbbells",
    "exercises": ["Pull-Ups", "Bench Press", "Tricep Dips", "Push-Ups"],
  },
];

String getExerciseImagePath(String exerciseName) {
  final name = exerciseName.toLowerCase();

  if (name.contains('squat')) return PhotoAssetsData.squats;
  if (name.contains('push')) return PhotoAssetsData.pushUps;
  if (name.contains('pull')) return PhotoAssetsData.pullUps;
  if (name.contains('jump rope')) return PhotoAssetsData.jumpRope;
  if (name.contains('high knees')) return PhotoAssetsData.highKnees;
  if (name.contains('jog')) return PhotoAssetsData.jogging;
  if (name.contains('plank')) return PhotoAssetsData.planks;
  if (name.contains('russian twist')) return PhotoAssetsData.russianTwists;
  if (name.contains('bicycle crunch')) return PhotoAssetsData.bicycleCrunches;
  if (name.contains('dead bug')) return PhotoAssetsData.deadBug;
  if (name.contains('bench press')) return PhotoAssetsData.benchPress;
  if (name.contains('tricep dip')) return PhotoAssetsData.tricepDips;

  return PhotoAssetsData.placeholder;
}

String getBannerImageForWorkout(String title) {
  final lowerTitle = title.toLowerCase();
  if (lowerTitle.contains('cardio kickstart')) {
    return PhotoAssetsData.cardioKickstartBanner;
  } else if (lowerTitle.contains('core strength')) {
    return PhotoAssetsData.coreStrengthBanner;
  } else if (lowerTitle.contains('full body blast')) {
    return PhotoAssetsData.fullBodyBlastBanner;
  } else if (lowerTitle.contains('upper body power')) {
    return PhotoAssetsData.upperBodyPowerBanner;
  } else {
    return PhotoAssetsData.banner;
  }
}
