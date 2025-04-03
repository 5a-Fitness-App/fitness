import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityField {
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

  ActivityField(
      {required this.exerciseType,
      this.notes = '',
      this.reps,
      this.weight,
      this.weightMetric = 'kgs',
      this.distance,
      this.time = '',
      this.incline,
      this.speed});

  ActivityField copyWith(
      {String? exerciseType,
      String? notes,
      int? reps,
      double? weight,
      String? weightMetric,
      double? distance,
      String? time,
      double? incline,
      double? speed}) {
    return ActivityField(
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

  void editTime() {}
}

class WorkoutDraft {
  final List<ActivityField> activities;
  String caption;
  WorkoutDraft({required this.activities, this.caption = ''});
  WorkoutDraft copyWith({List<ActivityField>? activites, String? caption}) {
    return WorkoutDraft(
        activities: activites ?? activities, caption: caption ?? this.caption);
  }

  void deleteActivity(ActivityField activity) {}
}

final workoutDraftProvider = StateProvider<int>((ref) => 1);

final workoutDraftNotifier =
    StateNotifierProvider<WorkoutDraftNotifier, WorkoutDraft>((ref) {
  return WorkoutDraftNotifier(ref);
});

class WorkoutDraftNotifier extends StateNotifier<WorkoutDraft> {
  final Ref ref;

  WorkoutDraftNotifier(this.ref) : super(WorkoutDraft(activities: []));

  List<ActivityField> getActivities() {
    return state.activities;
  }

  void addActivity(ActivityField activity) {
    // if (activity = re)
    List<ActivityField> activities = state.activities;
    activities.add(activity);
    state = state.copyWith(activites: activities);
    print("activity added");
  }

  void deleteActivity(ActivityField activity) {
    List<ActivityField> activities = state.activities;
    activities.remove(activity);
    state = state.copyWith(activites: activities);
    print("activity removed");
  }

  String post() {
    //createWorkout
    return 'Post successful';
  }
}
