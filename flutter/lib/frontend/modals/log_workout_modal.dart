import 'dart:collection';
import 'package:fitness_app/backend/models/workout_draft.dart';
import 'package:fitness_app/backend/provider/workout_draft_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

typedef ActivityEntry = DropdownMenuEntry<ExerciseTypeLabel>;

// DropdownMenuEntry labels and values for the first dropdown menu.
enum ExerciseTypeLabel {
  // Legs
  backSquats('Back Squats', ['sets', 'reps', 'weight']),
  frontSquats('Front Squats', ['sets', 'reps', 'weight']),
  hackSquats('Hack Squats', ['sets', 'reps', 'weight']),
  bulgarianSplitSquats('Bulgarian Split Squats', ['sets', 'reps', 'weight']),
  stepUps('Step-ups', ['sets', 'reps', 'weight']),
  gobletSquats('Goblet Squats', ['sets', 'reps', 'weight']),
  rdls('RDLS', ['sets', 'reps', 'weight']),
  legExtensions('Leg Extensions (Machine)', ['sets', 'reps', 'weight']),
  legCurls('Leg Curls (Machine)', ['sets', 'reps', 'weight']),
  calfRaises('Calf Raises', ['sets', 'reps', 'weight']),
  singleLegLegPress('Single-leg Leg Press', ['sets', 'reps', 'weight']),
  deadlifts('Deadlifts', ['sets', 'reps', 'weight']),

  // Glutes
  hipThrust('Hip Thrust', ['sets', 'reps', 'weight']),
  donkeyKick('Donkey Kick', ['sets', 'reps', 'weight']),
  hipAbductor('Hip Abductor', ['sets', 'reps', 'weight']),

  // Chest
  benchPress('Bench Press', ['sets', 'reps', 'weight']),
  chestFlys('Chest Flys', ['sets', 'reps', 'weight']),
  pushUps('Push-Ups', ['sets', 'reps']),
  dumbbellChestPress('Dumbbell Chest Press', ['sets', 'reps', 'weight']),
  chestPressMachine('Chest Press (Machine)', ['sets', 'reps', 'weight']),

  rowsBarbell('Rows (Barbell)', ['sets', 'reps', 'weight']),
  rowsDumbbell('Rows (Dumbbell)', ['sets', 'reps', 'weight']),
  latPulldown('Lat Pulldown', ['sets', 'reps', 'weight']),
  tBarRows('T-Bar Rows', ['sets', 'reps', 'weight']),

  // Back
  latRowsMachine('Lat Rows (Machine)', ['sets', 'reps', 'weight']),
  latRowsCable('Lat Rows (Cable)', ['sets', 'reps', 'weight']),
  upperBackRowsMachine('Upper Back Rows (Machine)', ['sets', 'reps', 'weight']),
  upperBackRowsCable('Upper Back Rows (Cable)', ['sets', 'reps', 'weight']),
  pullovers('Pullovers', ['sets', 'reps', 'weight']),
  pullUps('Pull-ups', ['sets', 'reps']),

  // Shoulders
  overheadPress('Overhead Press', ['sets', 'reps', 'weight']),
  shoulderPress('Shoulder Press', ['sets', 'reps', 'weight']),
  latRaises('Lat Raises', ['sets', 'reps', 'weight']),
  frontRaises('Front Raises', ['sets', 'reps', 'weight']),
  rearDeltFlys('Rear Delt Flys', ['sets', 'reps', 'weight']),
  facePulls('Face Pulls', ['sets', 'reps', 'weight']),
  shrugs('Shrugs', ['sets', 'reps', 'weight']),

  // Biceps
  bicepCurls('Bicep Curls', ['sets', 'reps', 'weight']),
  hammerCurls('Hammer Curls', ['sets', 'reps', 'weight']),
  barbellCurls('Barbell Curls', ['sets', 'reps', 'weight']),
  preacherCurls('Preacher Curls', ['sets', 'reps', 'weight']),
  concentrationCurls('Concentration Curls', ['sets', 'reps', 'weight']),

  // Triceps
  tricepDips('Tricep Dips', ['sets', 'reps', 'weight']),
  tricepPushdowns('Tricep Pushdowns', ['sets', 'reps', 'weight']),
  skullCrushers('Skull Crushers', ['sets', 'reps', 'weight']),
  closeGripBenchPress('Close-Grip Bench Press', ['sets', 'reps', 'weight']),
  overheadTricepExtensions(
      'Overhead Tricep Extensions', ['sets', 'reps', 'weight']),

  // Core
  planks('Planks', ['sets', 'time', 'weight']),
  russianTwists('Russian Twists', ['sets', 'reps', 'weight']),
  legRaises('Leg Raises', ['sets', 'reps', 'weight']),
  sitUps('Sit-Ups', ['sets', 'reps', 'weight']),
  bicycleCrunches('Bicycle Crunches', ['sets', 'reps', 'weight']),
  hangingLegRaises('Hanging Leg Raises', ['sets', 'reps', 'weight']),
  cableWoodchoppers('Cable Woodchoppers', ['sets', 'reps', 'weight']),
  abRollouts('Ab Rollouts', ['sets', 'reps']),

  // Cardio
  running('Running', ['time', 'distance']),
  walking('Walking', ['time', 'distance']),
  treadmill('Treadmill', ['time', 'incline', 'distance', 'speed']),
  cycling('Cycling', ['time', 'distance']),
  swimming('Swimming', ['time', 'distance']),
  rowing('Rowing', ['time', 'distance']),
  jumpingJacks('Jumping Jacks', ['time']),
  stairClimbing('Stair Climbing', ['time', 'incline', 'distance']);

  const ExerciseTypeLabel(this.label, this.metrics);
  final String label;
  final List<String> metrics;

  static final List<ActivityEntry> entries =
      UnmodifiableListView<ActivityEntry>(
    values
        .map<ActivityEntry>(
          (ExerciseTypeLabel activity) => ActivityEntry(
            value: activity,
            label: activity.label,
            enabled: activity.label != 'Grey',
          ),
        )
        .toList(),
  );
}

// Main page for logging workouts
class LogWorkoutPage extends ConsumerStatefulWidget {
  const LogWorkoutPage({super.key});

  @override
  LogWorkoutPageState createState() => LogWorkoutPageState();
}

// State class for LogWorkoutPage
class LogWorkoutPageState extends ConsumerState<LogWorkoutPage> {
  final TextEditingController activityController = TextEditingController();
  ExerciseTypeLabel? selectedExercise;

  @override
  void dispose() {
    activityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Set default selected exercise
    setState(() {
      selectedExercise = ExerciseTypeLabel.running;
    });
  }

  // Function to post the workout
  void postWorkout() {
    ref.read(workoutDraftNotifier.notifier).post();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Get current workout draft state
    final workoutDraft = ref.watch(workoutDraftNotifier);
    final activities = workoutDraft.activities;
    final workoutKey = GlobalKey<FormState>();

    //  a FocusNode for controlling the keyboard focus
    final focusNode = FocusNode();

    return GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Form(
                key: workoutKey,
                child: Column(children: [
                  // Header with cancel and post buttons
                  Container(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, left: 10, right: 15),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel button
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ref.read(workoutDraftNotifier.notifier).cancel();
                            },
                            child: const Text(
                              'Cancel',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            )),
                        // Post button
                        ElevatedButton(
                            onPressed: postWorkout,
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    const Color.fromARGB(255, 80, 162, 255),
                                foregroundColor: Colors.white),
                            child: const Text(
                              'Post',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  // Caption input field
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              autofocus: false,
                              autocorrect: false,
                              focusNode: focusNode,
                              controller: workoutDraft.captionController,
                              keyboardType: TextInputType.multiline,
                              minLines: 5,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Write a caption...',
                              ),
                            ),
                          ])),
                  const Divider(),
                  // List of activities
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Placeholder when no activities added
                          if (activities.isEmpty)
                            const Text(
                              'Add an activity',
                              style: TextStyle(color: Colors.grey),
                            ),
                          // Display each activity
                          for (ActivityDraft activity in activities)
                            ActivityWidget(
                              activity: activity,
                            )
                        ],
                      ),
                    ),
                  ),
                  // Bottom section with add activity controls
                  Container(
                    padding: const EdgeInsets.only(bottom: 30, top: 10),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide.none,
                            left: BorderSide.none,
                            right: BorderSide.none,
                            top: BorderSide(
                                color: Color.fromARGB(255, 230, 230, 230)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add activity button
                        ElevatedButton.icon(
                            onPressed: () {
                              ref
                                  .read(workoutDraftNotifier.notifier)
                                  .addActivity(selectedExercise!.label,
                                      selectedExercise!.metrics);
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    const Color.fromARGB(255, 80, 162, 255),
                                foregroundColor: Colors.white),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text('Add Activity',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        // Exercise type dropdown
                        DropdownMenu<ExerciseTypeLabel>(
                            enableFilter: false,
                            enableSearch: false,
                            width: 200,
                            initialSelection: selectedExercise,
                            controller: activityController,
                            dropdownMenuEntries: ExerciseTypeLabel.entries,
                            helperText: 'Select an activity to add',
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 230, 230, 230),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.all(10),
                            ),
                            onSelected: (ExerciseTypeLabel? activity) {
                              setState(() {
                                selectedExercise = activity;
                              });
                            }),
                      ],
                    ),
                  )
                ]))));
  }
}

// Widget for displaying and editing a single activity
class ActivityWidget extends ConsumerStatefulWidget {
  final ActivityDraft activity;

  const ActivityWidget({super.key, required this.activity});

  @override
  ActivityWidgetState createState() => ActivityWidgetState();
}

// State class for ActivityWidget
class ActivityWidgetState extends ConsumerState<ActivityWidget> {
  ActivityDraft? activity;
  final _formKey = GlobalKey<FormState>();

  // Helper method to build time input fields
  Widget _buildTimeField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2), // Max 2 digits
      ],
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          )),
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        final num = int.tryParse(value);
        if (num == null || num < 0) return 'Invalid';

        // Additional validation for minutes/seconds
        if (label == 'MM' || label == 'SS') {
          if (num > 59) return 'Max 59';
        }
        return null;
      },
    );
  }

  // Build time input fields (hours, minutes, seconds)
  Widget _buildTimeInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Time', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: [
            // Hours field
            Expanded(
              child: _buildTimeField(
                controller: widget.activity.hoursController,
                label: 'HH',
              ),
            ),
            const SizedBox(width: 8),
            // Minutes field
            Expanded(
              child: _buildTimeField(
                controller: widget.activity.minutesController,
                label: 'MM',
              ),
            ),
            const SizedBox(width: 8),
            // Seconds field
            Expanded(
              child: _buildTimeField(
                controller: widget.activity.secondsController,
                label: 'SS',
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(workoutDraftNotifier);
    return Form(
        key: _formKey,
        child: Column(children: [
          const SizedBox(height: 20),
          // Activity container
          Container(
            width: MediaQuery.of(context).size.width - 20,
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border.all(color: const Color.fromARGB(255, 230, 230, 230)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                // Exercise type name
                Text(widget.activity.exerciseType,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),

                // Reps field (if applicable)
                if (widget.activity.metrics.contains('reps'))
                  TextFormField(
                    controller: widget.activity.repsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter sets';
                      if (int.tryParse(value) == null)
                        return 'Enter valid number';
                      return null;
                    },
                  ),

                // Sets field (if applicable)
                if (widget.activity.metrics.contains('sets'))
                  TextFormField(
                    controller: widget.activity.setsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Sets',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter sets';
                      if (int.tryParse(value) == null)
                        return 'Enter valid number';
                      return null;
                    },
                  ),

                // Time inputs (if applicable)
                if (widget.activity.metrics.contains('time'))
                  _buildTimeInputs(),

                // Weight input (if applicable)
                if (widget.activity.metrics.contains('weight'))
                  SizedBox(
                      height: 100,
                      child: Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          // Weight value field
                          Expanded(
                            child: TextFormField(
                              controller: widget.activity.weightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$')),
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Enter your weight',
                                labelText: 'Weight',
                                prefixIcon: Icon(Icons.monitor_weight_outlined),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a number';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Invalid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          // Weight unit dropdown
                          DropdownMenu<WeightUnitsLabel>(
                              enableFilter: false,
                              enableSearch: false,
                              width: 125,
                              initialSelection:
                                  widget.activity.selectedWeightUnit,
                              controller: widget.activity.weightUnitsController,
                              dropdownMenuEntries: WeightUnitsLabel.entries,
                              helperText: 'Select weight unit',
                              inputDecorationTheme: InputDecorationTheme(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 230, 230, 230),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.all(10),
                              ),
                              onSelected: (WeightUnitsLabel? weightUnit) {
                                ref
                                    .read(workoutDraftNotifier.notifier)
                                    .setWeightUnit(
                                        widget.activity, weightUnit!);
                              })
                        ],
                      )),

                // Distance input (if applicable)
                if (widget.activity.metrics.contains('distance'))
                  SizedBox(
                      height: 100,
                      child: Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          // Distance value field
                          Expanded(
                            child: TextFormField(
                              controller: widget.activity.distanceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$')),
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Enter Distance',
                                labelText: 'Distance',
                                prefixIcon: Icon(Icons.monitor_weight_outlined),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a number';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Invalid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          // Distance unit dropdown
                          DropdownMenu<DistanceUnitsLabel>(
                              enableFilter: false,
                              enableSearch: false,
                              width: 125,
                              initialSelection:
                                  widget.activity.selectedDistanceUnit,
                              controller:
                                  widget.activity.distanceUnitsController,
                              dropdownMenuEntries: DistanceUnitsLabel.entries,
                              helperText: 'Select distance unit',
                              inputDecorationTheme: InputDecorationTheme(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 230, 230, 230),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.all(10),
                              ),
                              onSelected: (DistanceUnitsLabel? distanceUnits) {
                                ref
                                    .read(workoutDraftNotifier.notifier)
                                    .setDistanceUnit(
                                        widget.activity, distanceUnits!);
                              })
                        ],
                      )),

                // Speed input (if applicable)
                if (widget.activity.metrics.contains('speed'))
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      controller: widget.activity.speedController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$')),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Enter speed',
                        labelText: 'Speed',
                        prefixIcon: Icon(Icons.speed),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a number';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),

                // Incline input (if applicable)
                if (widget.activity.metrics.contains('incline'))
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      controller: widget.activity.inclineController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$')),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Enter incline',
                        labelText: 'Incline',
                        prefixIcon: Icon(Icons.arrow_upward),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a number';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),

                // Notes field
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: TextFormField(
                    controller: widget.activity.notesController,
                    autofocus: true,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write some notes...',
                    ),
                  ),
                ),

                // Delete button
                ElevatedButton.icon(
                    onPressed: () {
                      ref
                          .read(workoutDraftNotifier.notifier)
                          .deleteActivity(widget.activity);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            const Color.fromARGB(255, 230, 230, 230),
                        foregroundColor: Colors.black),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Delete',
                      style: TextStyle(fontSize: 16),
                    )),
              ],
            ),
          )
        ]));
  }
}
