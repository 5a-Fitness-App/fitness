import 'package:fitness_app/backend/api.dart';
import 'package:fitness_app/backend/models/workout_draft.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/models/user.dart';

// Provider for tracking workout draft ID
final workoutDraftProvider = StateProvider<int>((ref) => 1);

// StateNotifierProvider for managing workout draft state
final workoutDraftNotifier =
    StateNotifierProvider<WorkoutDraftNotifier, WorkoutDraft>((ref) {
  return WorkoutDraftNotifier(ref);
});

// StateNotifier class for handling workout draft operations
class WorkoutDraftNotifier extends StateNotifier<WorkoutDraft> {
  final Ref ref; // Reference to provider container

  // Initialize with empty workout draft
  WorkoutDraftNotifier(this.ref)
      : super(WorkoutDraft(
            activities: [], captionController: TextEditingController()));

  // Getter for current activities list
  List<ActivityDraft> getActivities() {
    return state.activities;
  }

  // Adds a new activity to the workout draft
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

  // Removes an activity from the workout draft
  void deleteActivity(ActivityDraft activity) {
    List<ActivityDraft> activities = state.activities;
    activities.remove(activity);
    state = state.copyWith(activities: activities);
    print("activity removed");
  }

  // Updates the distance unit for a specific activity
  void setDistanceUnit(
      ActivityDraft updatedActivity, DistanceUnitsLabel distanceUnit) {
    // Map through activities to find and update the target one
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

  // Updates the weight unit for a specific activity
  void setWeightUnit(
      ActivityDraft updatedActivity, WeightUnitsLabel weightUnit) {
    // Map through activities to find and update the target one
    List<ActivityDraft> updatedActivities = state.activities.map((activity) {
      if (activity.activityDraftID == updatedActivity.activityDraftID) {
        // Update the weight unit field on a copy of the original activity
        return activity.copyWith(weightUnit: weightUnit);
      } else {
        return activity;
      }
    }).toList();

    state = state.copyWith(activities: updatedActivities);
    print("distance updated");
  }

  Future<String> post(
      // bool workoutPublic, -> not implemented, available for future use: the default when a user posts a workout is public, and they can set it to private later.
      ) async {
    // Convert current state to map for API request
    Map<String, dynamic> workout = state.toMap();

    // Get current user info
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    // If user is logged in, post the workout
    if (userID != null) {
      await addWorkout(
          userID, workout['workout_caption'], true, workout['activities']);
    }

    // Clear the draft after posting
    state.captionController.clear();
    state = state.copyWith(activities: []);
    return 'Post successful';
  }

  // Cancels the current workout draft and clears all data
  void cancel() {
    state.captionController.clear();
    state = state.copyWith(activities: []);
  }
}
