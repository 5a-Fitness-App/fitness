import 'package:flutter/material.dart';
import 'dart:collection';

// type for Weight Units drop down menu
typedef WeightUnits = DropdownMenuEntry<WeightUnitsLabel>;

// Enumeration for selecting weight units with the label text they display
enum WeightUnitsLabel {
  kg('kg'),
  lb('lb');

  const WeightUnitsLabel(this.label);
  final String label;

  static final List<WeightUnits> entries = UnmodifiableListView<WeightUnits>(
    values
        .map<WeightUnits>(
          (WeightUnitsLabel weightUnits) => WeightUnits(
            value: weightUnits,
            label: weightUnits.label,
            enabled: weightUnits.label != 'Grey',
          ),
        )
        .toList(),
  );
}

// Type for Distance Units drop down menu
typedef DistanceUnits = DropdownMenuEntry<DistanceUnitsLabel>;

// Enumeration for selecting distance units with the label text they display
enum DistanceUnitsLabel {
  mi('mi'),
  km('km');

  const DistanceUnitsLabel(this.label);
  final String label;

  static final List<DistanceUnits> entries =
      UnmodifiableListView<DistanceUnits>(
    values
        .map<DistanceUnits>(
          (DistanceUnitsLabel distanceUnit) => DistanceUnits(
            value: distanceUnit,
            label: distanceUnit.label,
            enabled: distanceUnit.label != 'Grey',
          ),
        )
        .toList(),
  );
}

// Class representing an activity draft with all possible metrics
// Metrics used depend on the exercise type
class ActivityDraft {
  final int activityDraftID; // Unique identifier to
  final String
      exerciseType; // Type of exercise (e.g. Running, Treadmill, DeadLifts)

  // The list of metrics being tracked for this activty. Dependent on exercise type that the user selects from frontend/states/log_workout_modal.dart
  final List<String> metrics;

  // Input fields
  final TextEditingController notesController;

  // Rep controller
  final TextEditingController repsController;

  // Set controller
  final TextEditingController setsController;

  // Weight controllers
  final TextEditingController weightController;
  final TextEditingController weightUnitsController;
  WeightUnitsLabel? selectedWeightUnit;

  // Time controllers
  final TextEditingController hoursController;
  final TextEditingController minutesController;
  final TextEditingController secondsController;

  // Distance controllers
  final TextEditingController distanceController;
  final TextEditingController distanceUnitsController;
  DistanceUnitsLabel? selectedDistanceUnit;

  // Other metric controllers
  final TextEditingController speedController;
  final TextEditingController inclineController;

  ActivityDraft({
    required this.activityDraftID,
    required this.exerciseType,
    required this.metrics,
    required this.notesController,
    required this.setsController,
    required this.repsController,
    required this.hoursController,
    required this.minutesController,
    required this.secondsController,
    required this.weightController,
    required this.weightUnitsController,
    this.selectedWeightUnit,
    required this.distanceController,
    required this.distanceUnitsController,
    this.selectedDistanceUnit,
    required this.speedController,
    required this.inclineController,
  });

  ActivityDraft copyWith(
      {WeightUnitsLabel? weightUnit, DistanceUnitsLabel? distanceUnit}) {
    return ActivityDraft(
      activityDraftID: activityDraftID,
      exerciseType: exerciseType,
      metrics: metrics,
      notesController: notesController,
      setsController: setsController,
      repsController: repsController,
      hoursController: hoursController,
      minutesController: minutesController,
      secondsController: secondsController,
      weightController: weightController,
      weightUnitsController: weightUnitsController,
      selectedWeightUnit: weightUnit ?? selectedWeightUnit,
      distanceController: distanceController,
      distanceUnitsController: distanceUnitsController,
      selectedDistanceUnit: distanceUnit ?? selectedDistanceUnit,
      speedController: speedController,
      inclineController: inclineController,
    );
  }

  // Converts to map to insert as a JSON into the database when the workout draft is posted
  Map<String, dynamic> toMap() {
    return {
      'exercise_name': exerciseType,
      if (notesController.text.isNotEmpty) 'notes': notesController.text.trim(),
      'metrics': {
        if (_parseInt(setsController.text) != null)
          'sets': _parseInt(setsController.text),
        if (_parseInt(repsController.text) != null)
          'reps': _parseInt(repsController.text),
        if (_parseDouble(weightController.text) != null)
          'weight': _parseDouble(weightController.text),
        if (weightUnitsController.text.isNotEmpty)
          'unit': weightUnitsController.text,
        if (_parseDouble(distanceController.text) != null)
          'distance': _parseDouble(distanceController.text),
        if (distanceUnitsController.text.isNotEmpty)
          'unit': distanceUnitsController.text,
        if (_formattedTime().isNotEmpty) 'time': _formattedTime(),
        if (_parseDouble(inclineController.text) != null)
          'incline': _parseDouble(inclineController.text),
        if (_parseDouble(speedController.text) != null)
          'speed': _parseDouble(speedController.text),
      }
    };
  }

  // Helper method to parse a string into a double (returns null if invalid)
  double? _parseDouble(String text) {
    final value = double.tryParse(text.trim());
    return value?.isFinite == true ? value : null;
  }

  // Helper method to parse a string into an integer (returns null if invalid)
  int? _parseInt(String text) {
    final value = int.tryParse(text.trim());
    return value?.isFinite == true ? value : null;
  }

  // Formats time from hours, minutes, seconds controllers into HH:MM:SS format
  String _formattedTime() {
    final h = hoursController.text.trim();
    final m = minutesController.text.trim();
    final s = secondsController.text.trim();
    if (h.isEmpty && m.isEmpty && s.isEmpty) return '';
    return '${h.padLeft(2, '0')}:${m.padLeft(2, '0')}:${s.padLeft(2, '0')}';
  }
}

// Class representing a workout draft containing multiple activities
class WorkoutDraft {
  final List<ActivityDraft> activities; // List of activities in the workout
  final TextEditingController
      captionController; // Controller for workout caption

  WorkoutDraft({required this.activities, required this.captionController});

  WorkoutDraft copyWith({List<ActivityDraft>? activities}) {
    return WorkoutDraft(
        activities: activities ?? this.activities,
        captionController: captionController);
  }

  // Converts to map to insert as a JSON into the database when the workout draft is posted
  Map<String, dynamic> toMap() {
    return {
      'workout_caption': captionController.text.trim(),
      'activities': activities.map((activity) => activity.toMap()).toList(),
    };
  }
}
