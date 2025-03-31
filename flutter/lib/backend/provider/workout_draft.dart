import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseField {
  String exerciseType;
  String notes;

  //Strength fields
  int? reps;
  double? weight;
  String weightMetric;

  //Cardio fields
  double? distance;
  String time;
  double? incline;
  double? speed;

  ExerciseField(
      {required this.exerciseType,
      this.notes = '',
      this.reps,
      this.weight,
      this.weightMetric = 'kgs',
      this.distance,
      this.time = '',
      this.incline,
      this.speed});

  ExerciseField copyWith(
      {String? exerciseType,
      String? notes,
      int? reps,
      double? weight,
      String? weightMetric,
      double? distance,
      String? time,
      double? incline,
      double? speed}) {
    return ExerciseField(
        exerciseType: exerciseType ?? this.exerciseType,
        notes: notes ?? this.notes,
        reps: reps ?? this.reps,
        weight: weight ?? this.weight,
        weightMetric: weightMetric ?? this.weightMetric,
        distance: distance ?? this.distance,
        time: time ?? this.time,
        incline: incline ?? this.incline,
        speed: speed ?? this.speed);
  }
}

class WorkoutDraft {
  final List<ExerciseField> activities;
  String caption;
  WorkoutDraft({required this.activities, this.caption = ''});
  WorkoutDraft copyWith({List<ExerciseField>? activites, String? caption}) {
    return WorkoutDraft(
        activities: activites ?? activities, caption: caption ?? this.caption);
  }

  void deleteActivity(ExerciseField activity) {}
}

final workoutDraftProvider = StateProvider<int>((ref) => 1);

final workoutDraftNotifier =
    StateNotifierProvider<WorkoutDraftNotifier, WorkoutDraft>((ref) {
  return WorkoutDraftNotifier(ref);
});

class WorkoutDraftNotifier extends StateNotifier<WorkoutDraft> {
  final Ref ref;

  WorkoutDraftNotifier(this.ref) : super(WorkoutDraft(activities: []));

  List<ExerciseField> getActivities() {
    return state.activities;
  }
}
