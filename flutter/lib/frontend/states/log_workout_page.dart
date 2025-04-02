import 'dart:collection';

import 'package:fitness_app/backend/provider/workout_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return SingleChildScrollView(
        child: Column(children: [
      Container(
        width: MediaQuery.of(context).size.width - 20,
        child: TextFormField(
          autofocus: true,
          autocorrect: false,
          keyboardType: TextInputType.multiline,
          minLines: 4,
          maxLines: 4,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Write a caption...',
          ),
        ),
      ),
      const Divider(thickness: 1.5),
      const SizedBox(
        height: 10,
      ),
      Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropdownMenu<ActivityLabel>(
                enableFilter: false,
                enableSearch: false,
                initialSelection: ActivityLabel.cardio,
                controller: activityController,
                dropdownMenuEntries: ActivityLabel.entries,
                inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 110, 110, 110)),
                        borderRadius: BorderRadius.circular(10))),
                onSelected: (ActivityLabel? activity) {
                  setState(() {
                    selectedActivity = activity;
                    activityController.text = activity?.label ?? 'cardio';
                  });
                }),
            ElevatedButton.icon(
                onPressed: () {
                  ref.read(workoutDraftNotifier.notifier).addActivity(
                      ExerciseField(
                          exerciseType:
                              selectedActivity!.label) // Use enum value
                      );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Activity'))
          ]),
      const SizedBox(height: 10),
      const Divider(thickness: 1.5),
      for (ExerciseField activity in activities)
        ActivityWidget(activity: activity)
    ]));
  }
}

class ActivityWidget extends ConsumerWidget {
  final ExerciseField activity;

  const ActivityWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(workoutDraftNotifier);

    Map<String, List<String>> exercises = {
      'Cardio': ['time', 'speed', 'distance'],
      'Strength': ['reps', 'weight'],
      'Swimming': ['time', 'distance']
    };

    String exerciseType = activity.exerciseType;

    return Column(children: [
      SizedBox(height: 20),
      Container(
        width: MediaQuery.of(context).size.width - 20,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(50, 0, 0, 0),
                spreadRadius: 1.0,
                blurRadius: 4.0,
                offset: Offset(0, 0))
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exerciseType,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (exercises[exerciseType]!.contains('time'))
              const Text(
                'Time',
                style: TextStyle(fontSize: 20),
              ),
            if (exercises[exerciseType]!.contains('weight'))
              Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Weight',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(onPressed: () {}, child: Text('hi'))
                  ]),
            const SizedBox(width: 10),
            Container(
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
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Delete'))
          ],
        ),
      )
    ]);
  }
}
