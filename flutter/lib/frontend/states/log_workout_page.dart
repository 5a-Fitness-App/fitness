import 'dart:collection';

import 'package:fitness_app/functional_backend/provider/workout_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

typedef ActivityEntry = DropdownMenuEntry<ActivityLabel>;

// DropdownMenuEntry labels and values for the first dropdown menu.
enum ActivityLabel {
  cardio('Cardio'),
  swimming('Swimming'),
  strength('Strength');

  const ActivityLabel(this.label);
  final String label;

  static final List<ActivityEntry> entries =
      UnmodifiableListView<ActivityEntry>(
    values.map<ActivityEntry>(
      (ActivityLabel activity) => ActivityEntry(
        value: activity,
        label: activity.label,
        enabled: activity.label != 'Grey',
      ),
    ),
  );
}

class LogWorkoutPage extends ConsumerStatefulWidget {
  const LogWorkoutPage({super.key});

  @override
  LogWorkoutPageState createState() => LogWorkoutPageState();
}

class LogWorkoutPageState extends ConsumerState<LogWorkoutPage> {
  final TextEditingController activityController = TextEditingController();
  ActivityLabel? selectedActivity;

  @override
  void dispose() {
    activityController.dispose;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      selectedActivity = ActivityLabel.cardio;
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutDraft = ref.watch(workoutDraftNotifier);
    final activities = workoutDraft.activities;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 10, right: 15),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        )),
                    ElevatedButton(
                        onPressed: () {},
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
              Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          autofocus: true,
                          autocorrect: false,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (activities.isEmpty)
                        const Text(
                          'Add an activity',
                          style: TextStyle(color: Colors.grey),
                        ),
                      for (ActivityField activity in activities)
                        ActivityWidget(activity: activity)
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 30, top: 10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide.none,
                        left: BorderSide.none,
                        right: BorderSide.none,
                        top: BorderSide(
                            color: Color.fromARGB(255, 230, 230, 230)))),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          ref.read(workoutDraftNotifier.notifier).addActivity(
                              ActivityField(
                                  exerciseType:
                                      selectedActivity!.label) // Use enum value
                              );
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
                                fontSize: 16, fontWeight: FontWeight.bold))),
                    DropdownMenu<ActivityLabel>(
                        enableFilter: false,
                        enableSearch: false,
                        width: 200,
                        initialSelection: ActivityLabel.cardio,
                        controller: activityController,
                        dropdownMenuEntries: ActivityLabel.entries,
                        helperText: 'Select an activity to add',
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 230, 230, 230),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                        onSelected: (ActivityLabel? activity) {
                          setState(() {
                            selectedActivity = activity;
                          });
                        }),
                  ],
                ),
              )
            ])));
  }
}

class ActivityWidget extends ConsumerWidget {
  final ActivityField activity;

  const ActivityWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(workoutDraftNotifier);
    Map<String, List<String>> exercises = {
      'Cardio': ['time', 'speed', 'distance'],
      'Strength': ['reps', 'weight'],
      'Swimming': ['time', 'distance']
    };

    // TextEditingController hourController = TextEditingController();
    // TextEditingController minuteController = TextEditingController();

    // TextEditingController weightController = TextEditingController();
    // TextEditingController weightMetricController = TextEditingController();

    // TextEditingController distanceController = TextEditingController();
    // TextEditingController speedController = TextEditingController();
    // TextEditingController inclineController = TextEditingController();

    String exerciseType = activity.exerciseType;

    return Column(children: [
      const SizedBox(height: 20),
      Container(
        width: MediaQuery.of(context).size.width - 20,
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color.fromARGB(255, 230, 230, 230)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(exerciseType,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (exercises[exerciseType]!.contains('time'))
              const Text(
                'Time',
                style: TextStyle(fontSize: 16),
              ),
            if (exercises[exerciseType]!.contains('weight'))
              Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 30,
                  children: [
                    const Text(
                      'Weight:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                        child: TextFormField(
                      // controller: weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // Numeric keyboard
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'^\d*\.?\d*$')), // Allow only numbers and a decimal point
                      ],
                      decoration: const InputDecoration(
                        labelText: "Enter a decimal number",
                        border: OutlineInputBorder(),
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
                    )),
                  ]),
            if (exercises[exerciseType]!.contains('reps'))
              Flex(direction: Axis.horizontal, spacing: 40, children: [
                const Text(
                  'Reps:',
                  style: TextStyle(fontSize: 16),
                ),
                Card(
                  color: const Color.fromARGB(255, 230, 230, 230),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16), // Custom border radius
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          ref
                              .read(workoutDraftNotifier.notifier)
                              .decrementReps(activity);
                        },
                      ),
                      Text(activity.reps.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          ref
                              .read(workoutDraftNotifier.notifier)
                              .incrementReps(activity);
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: TextFormField(
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
            ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(workoutDraftNotifier.notifier)
                      .deleteActivity(activity);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 230, 230, 230),
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
    ]);
  }
}
