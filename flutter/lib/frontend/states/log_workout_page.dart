import 'package:fitness_app/backend/provider/workout_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<String> exerciseList = <String>[
  'cardio',
  'strength',
  'swim',
  'yoga',
  'meditation'
];

class LogWorkoutPage extends ConsumerStatefulWidget {
  const LogWorkoutPage({super.key});

  @override
  LogWorkoutPageState createState() => LogWorkoutPageState();
}

class LogWorkoutPageState extends ConsumerState<LogWorkoutPage> {
  void buildExerciseField(
      ExerciseField activity, List<ExerciseField> activities) {
    String dropdownValue = exerciseList.first;

    Widget widget = Column(children: [
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
            DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                value: dropdownValue,
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items:
                    exerciseList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList()),
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
                  setState(() {
                    activities.remove(activity);
                  });
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Delete'))
          ],
        ),
      )
    ]);

    activities.add(activity);
  }

  @override
  Widget build(BuildContext context) {
    final workoutDraft = ref.watch(workoutDraftNotifier);
    final activities = workoutDraft.activities;

    return SingleChildScrollView(
      child: Column(
        children: [
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
          for (Widget activity in activities) activity,
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              onPressed: () {
                buildExerciseField();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Activity'))
        ],
      ),
    );
  }
}
