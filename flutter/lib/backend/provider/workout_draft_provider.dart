import 'package:fitness_app/backend/api.dart';
import 'package:fitness_app/backend/models/workout_draft.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/models/user.dart';

final workoutDraftProvider = StateProvider<int>((ref) => 1);

final workoutDraftNotifier =
    StateNotifierProvider<WorkoutDraftNotifier, WorkoutDraft>((ref) {
  return WorkoutDraftNotifier(ref);
});

class WorkoutDraftNotifier extends StateNotifier<WorkoutDraft> {
  final Ref ref;

  WorkoutDraftNotifier(this.ref)
      : super(WorkoutDraft(
            activities: [], captionController: TextEditingController()));

  List<ActivityDraft> getActivities() {
    return state.activities;
  }

  void addActivity(String exerciseName, List<String> metrics) {
    List<ActivityDraft> activities = state.activities;
    int activityID = activities.length + 1;
    ActivityDraft activity = ActivityDraft(
        activityDraftID: activityID,
        exerciseType: exerciseName,
        metrics: metrics,
        setsController: TextEditingController(),
        repsController: TextEditingController(),
        notesController: TextEditingController(),
        hoursController: TextEditingController(),
        minutesController: TextEditingController(),
        secondsController: TextEditingController(),
        weightController: TextEditingController(),
        weightUnitsController: TextEditingController(),
        distanceController: TextEditingController(),
        distanceUnitsController: TextEditingController(),
        speedController: TextEditingController(),
        inclineController: TextEditingController());
    activities.add(activity);
    state = state.copyWith(activities: activities);
    print("activity added");
  }

  void deleteActivity(ActivityDraft activity) {
    List<ActivityDraft> activities = state.activities;
    activities.remove(activity);
    state = state.copyWith(activities: activities);
    print("activity removed");
  }

  int? getSets(ActivityDraft activity) {
    return activity.sets;
  }

  int? getReps(ActivityDraft activity) {
    return activity.reps;
  }

  void setDistanceUnit(
      ActivityDraft updatedActivity, DistanceUnitsLabel distanceUnit) {
    List<ActivityDraft> updatedActivities = state.activities.map((activity) {
      if (activity.activityDraftID == updatedActivity.activityDraftID) {
        // Update the distance unit field on a copy of the original activity
        return activity.copyWith(distanceUnit: distanceUnit);
      } else {
        return activity;
      }
    }).toList();

    state = state.copyWith(activities: updatedActivities);
    print("distance updated");
  }

  void setWeightUnit(
      ActivityDraft updatedActivity, WeightUnitsLabel weightUnit) {
    List<ActivityDraft> updatedActivities = state.activities.map((activity) {
      if (activity.activityDraftID == updatedActivity.activityDraftID) {
        // Update the distance unit field on a copy of the original activity
        return activity.copyWith(weightUnit: weightUnit);
      } else {
        return activity;
      }
    }).toList();

    state = state.copyWith(activities: updatedActivities);
    print("distance updated");
  }

  Future<String> post(
      // bool workoutPublic,
      ) async {
    Map<String, dynamic> workout = state.toMap();
    print(workout);
    print(workout['workout_caption']);

    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      await addWorkout(
          userID, workout['workout_caption'], true, workout['activities']);
    }

    state.captionController.clear();
    state = state.copyWith(activities: []);
    return 'Post successful';
  }

  void cancel() {
    state.captionController.clear();
    state = state.copyWith(activities: []);
  }
}
