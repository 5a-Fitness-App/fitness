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
  String notes;

  // Strength fields
  int? sets;
  int? reps;

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
    this.notes = '',
    this.sets,
    this.reps,
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
      {String? notes,
      int? sets,
      int? reps,
      WeightUnitsLabel? weightUnit,
      DistanceUnitsLabel? distanceUnit}) {
    return ActivityDraft(
      activityDraftID: activityDraftID,
      exerciseType: exerciseType,
      metrics: metrics,
      notes: notes ?? this.notes,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
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
      'notes': notes,
      'metrics': {
        if (sets != null) 'sets': sets,
        if (reps != null) 'reps': reps,
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
  String caption;
  WorkoutDraft({required this.activities, this.caption = ''});
  WorkoutDraft copyWith({List<ActivityDraft>? activities, String? caption}) {
    return WorkoutDraft(
        activities: activities ?? this.activities,
        caption: caption ?? this.caption);
  }

  Map<String, dynamic> toMap() {
    return {
      'workout_caption': caption,
      'activities': activities.map((activity) => activity.toMap()).toList(),
    };
  }
}
