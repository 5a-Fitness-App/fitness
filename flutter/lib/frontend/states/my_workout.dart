import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/functional_backend/models/workout.dart';
import 'package:fitness_app/functional_backend/provider/user_provider.dart';

class MyWorkoutPage extends ConsumerStatefulWidget {
  const MyWorkoutPage({super.key});

  @override
  MyWorkoutPageState createState() => MyWorkoutPageState();
}

class MyWorkoutPageState extends ConsumerState<MyWorkoutPage> {
  final TextEditingController activityController = TextEditingController();

  @override
  void dispose() {
    activityController.dispose;
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();

  //   setState(() {
  //     selectedActivity = ActivityLabel.cardio;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final workoutDraft = ref.watch(workoutDraftNotifier);
    // final activities = workoutDraft.activities;

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
                    top: 20, bottom: 5, left: 3, right: 5),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(15),
                  child: const Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Workout title', style: TextStyle(fontSize: 20))
                      ])),
              const Divider(),
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [Text('no activties')],
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
                child: const Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('something')],
                ),
              )
            ])));
  }
}

class ActivityWidget extends ConsumerWidget {
  // final ActivityField activity;

  const ActivityWidget({super.key});

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

    // String exerciseType = activity.exerciseType;

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
                Text('exerciseType',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ]))
    ]);
  }
}
