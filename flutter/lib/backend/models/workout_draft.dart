import 'package:flutter/material.dart';
import 'dart:collection';

typedef WeightUnits = DropdownMenuEntry<WeightUnitsLabel>;

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

typedef DistanceUnits = DropdownMenuEntry<DistanceUnitsLabel>;

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

class ActivityDraft {
  final int activityDraftID;
  final String exerciseType;
  final List<String> metrics;
  final TextEditingController notesController;

  // Strength fields
  int? sets;
  int? reps;

  // Rep controller
  final TextEditingController repsController;

  // Set controllers
  final TextEditingController setsController;

  // Time controllers
  final TextEditingController hoursController;
  final TextEditingController minutesController;
  final TextEditingController secondsController;

  // Weight controllers
  final TextEditingController weightController;
  final TextEditingController weightUnitsController;
  WeightUnitsLabel? selectedWeightUnit;

  // Distance controllers
  final TextEditingController distanceController;
  final TextEditingController distanceUnitsController;
  DistanceUnitsLabel? selectedDistanceUnit;

  // Other metrics
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

  double? _parseDouble(String text) {
    final value = double.tryParse(text.trim());
    return value?.isFinite == true ? value : null;
  }

  int? _parseInt(String text) {
    final value = int.tryParse(text.trim());
    return value?.isFinite == true ? value : null;
  }

  String _formattedTime() {
    final h = hoursController.text.trim();
    final m = minutesController.text.trim();
    final s = secondsController.text.trim();
    if (h.isEmpty && m.isEmpty && s.isEmpty) return '';
    return '${h.padLeft(2, '0')}:${m.padLeft(2, '0')}:${s.padLeft(2, '0')}';
  }
}

class WorkoutDraft {
  final List<ActivityDraft> activities;
  final TextEditingController captionController;
  WorkoutDraft({required this.activities, required this.captionController});
  WorkoutDraft copyWith({List<ActivityDraft>? activities}) {
    return WorkoutDraft(
        activities: activities ?? this.activities,
        captionController: captionController);
  }

  Map<String, dynamic> toMap() {
    return {
      'workout_caption': captionController.text.trim(),
      'activities': activities.map((activity) => activity.toMap()).toList(),
    };
  }
}
