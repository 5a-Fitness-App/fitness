import 'package:fitness_app/functional_backend/api.dart';
import 'package:fitness_app/functional_backend/models/workout_draft.dart';
import 'package:fitness_app/functional_backend/provider/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/functional_backend/models/user.dart';

final workoutDraftProvider = StateProvider<int>((ref) => 1);

final workoutDraftNotifier =
    StateNotifierProvider<WorkoutDraftNotifier, WorkoutDraft>((ref) {
  return WorkoutDraftNotifier(ref);
});

class WorkoutDraftNotifier extends StateNotifier<WorkoutDraft> {
  final Ref ref;

  WorkoutDraftNotifier(this.ref) : super(WorkoutDraft(activities: []));

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

  void incrementReps(ActivityDraft activity) {
    List<ActivityDraft> activities = state.activities.map((a) {
      if (a == activity) {
        return a.copyWith(reps: (a.reps ?? 0) + 1);
      }
      return a;
    }).toList();

    state = state.copyWith(activities: activities);
  }

  void decrementReps(ActivityDraft activity) {
    if (activity.reps! > 0) {
      List<ActivityDraft> activities = state.activities.map((a) {
        if (a == activity) {
          return a.copyWith(reps: (a.reps ?? 0) - 1);
        }
        return a;
      }).toList();

      state = state.copyWith(activities: activities);
    }
  }

  void incrementSets(ActivityDraft activity) {
    List<ActivityDraft> activities = state.activities.map((a) {
      if (a == activity) {
        return a.copyWith(reps: (a.sets ?? 0) + 1);
      }
      return a;
    }).toList();

    state = state.copyWith(activities: activities);
  }

  void decrementSets(ActivityDraft activity) {
    if (activity.sets! > 0) {
      List<ActivityDraft> activities = state.activities.map((a) {
        if (a == activity) {
          return a.copyWith(reps: (a.sets ?? 0) - 1);
        }
        return a;
      }).toList();

      state = state.copyWith(activities: activities);
    }
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

  String post(
    String workoutCaption,
    // bool workoutPublic,
  ) {
    state.copyWith(
      caption: workoutCaption,
      // public: workoutPublic
    );

    Map<String, dynamic> workout = state.toMap();
    print(workout.toString());
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      addWorkout(
          userID, workout['workout_caption'], true, workout['activities']);
    }
    return 'Post successful';
  }
}
